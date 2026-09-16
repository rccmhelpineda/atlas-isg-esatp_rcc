{
  "Comment": "SAP to S3 multi-query extract using a single sap_2_s3 Glue job",
  "StartAt": "Extract_PRPS",
  "States": {
    "Extract_PRPS": {
      "Comment": "Full extract of SAPPRD.PRPS",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "prps",
          "--query": "SELECT \"MANDT\", \"PSPNR\", \"POSID\", \"POST1\", \"OBJNR\", \"PSPHI\", \"POSKI\", \"ERNAM\", \"ERDAT\", \"AENAM\", \"AEDAT\", \"VERNR\", \"VERNA\", \"ASTNR\", \"ASTNA\", \"PBUKR\", \"PGSBR\", \"PKOKR\", \"PRCTR\", \"PRART\", \"STUFE\", \"PLAKZ\", \"BELKZ\", \"FAKKZ\", \"NPFAZ\", \"ZUORD\", \"TRMEQ\", \"KVEWE\", \"KAPPL\", \"KALSM\", \"ZSCHL\", \"ABGSL\", \"AKOKR\", \"AKSTL\", \"FKOKR\", \"FKSTL\", \"FABKL\", \"PSPRI\", \"EQUNR\", \"TPLNR\", \"PWPOS\", \"WERKS\", \"TXTSP\", \"SLWID\", \"USR00\", \"USR01\", \"USR02\", \"USR03\", \"USR04\", \"USE04\", \"USR05\", \"USE05\", \"USR06\", \"USE06\", \"USR07\", \"USE07\", \"USR08\", \"USR09\", \"USR10\", \"USR11\", \"KOSTL\", \"KTRG\", \"BERST\", \"BERTR\", \"BERKO\", \"BERBU\", \"CLASF\", \"SPSNR\", \"SCOPE\", \"XSTAT\", \"TXJCD\", \"ZSCHM\", \"IMPRF\", \"EVGEW\", \"AENNR\", \"SUBPR\", \"POSTU\", \"PLINT\", \"LOEVM\", \"KZBWS\", \"FPLNR\", \"TADAT\", \"IZWEK\", \"ISIZE\", \"IUMKZ\", \"ABUKR\", \"GRPKZ\", \"PGPRF\", \"LOGSYSTEM\", \"PSPNR_LOGS\", \"STORT\", \"FUNC_AREA\", \"KLVAR\", \"KALNR\", \"POSID_EDIT\", \"PSPKZ\", \"MATNR\", \"VLPSP\", \"VLPKZ\", \"SORT1\", \"SORT2\", \"SORT3\", \"VNAME\", \"RECID\", \"ETYPE\", \"OTYPE\", \"JIBCL\", \"JIBSA\", \"CGPL_GUID16\", \"CGPL_LOGSYS\", \"CGPL_OBJTYPE\", \"ADPSP\", \"RFIPPNT\", \"FERC_IND\", \"EEW_PRPS_PS_DUMMY\", \"CPD_UPDAT\", \"PRPS_STATUS\" FROM \"SAPPRD\".\"PRPS\";",
          "--final_file_name": "from_SAP/for_ingestion/prps_output.json"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Load_PRPS"
    },
    "Load_PRPS": {
      "Comment": "Load SAPPRD.PRPS to Postgres",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "prps",   
          "--input_file_name": "from_SAP/for_ingestion/prps_output.json"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Notify_Success"
    },
    "Notify_Success": {
      "Type": "Task",
      "Resource": "arn:aws:states:::states:startExecution",
      "Parameters": {
        "StateMachineArn.$": "States.Format('arn:aws:states:{}:{}:stateMachine:{}-notifier-sf','${aws_region}','${aws_account_id}',$.env_prefix)",
        "Input": {
          "email_subject": "[SUCCESS] Daily ingestion of PRPS",
          "email_body": "✅ Processing Complete: Successfully synced S4HANA PRPS table."
        }
      },
      "End": true
    },

    "Notify_Fail": {
      "Type": "Task",
      "Resource": "arn:aws:states:::states:startExecution",
      "Parameters": {
        "StateMachineArn.$": "States.Format('arn:aws:states:{}:{}:stateMachine:{}-notifier-sf','${aws_region}','${aws_account_id}',$.env_prefix)",
        "Input": {
          "email_subject": "[FAILED] Daily ingestion of PRPS",
          "email_body.$": "States.Format('❌ Processing Failed: Unexpected issue was encountered while processing. \n\nError: {}\n\nPlease check the cloudwatch logs for details.', $.glue_error.Cause)"
        }
      },
      "ResultPath": null,
      "End": true
    }
  }
}