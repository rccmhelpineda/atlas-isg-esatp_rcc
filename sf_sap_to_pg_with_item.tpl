{
  "Comment": "SAP to S3 multi-query extract using a single sap_2_s3 Glue job",
  "StartAt": "Extract_WITH_ITEM",
  "States": {
    "Extract_WITH_ITEM": {
      "Comment": "Full extract of SAPPRD.WITH_ITEM",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "with_item",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"BELNR\", \"GJAHR\", \"BUZEI\", \"WITHT\", \"WT_WITHCD\", \"WT_QSSHH\", \"WT_QSSHB\", \"WT_QSSH2\", \"WT_QSSH3\", \"WT_BASMAN\", \"WT_QSSHHC\", \"WT_QSSHBC\", \"WT_QSSH2C\", \"WT_QSSH3C\", \"WT_QBSHH\", \"WT_QBSHB\", \"WT_QBSH2\", \"WT_QBSH3\", \"WT_AMNMAN\", \"WT_QBSHHA\", \"WT_QBSHHB\", \"WT_STAT\", \"WT_QSFHH\", \"WT_QSFHB\", \"WT_QSFH2\", \"WT_QSFH3\", \"WT_WTEXMN\", \"KOART\", \"WT_ACCO\", \"HKONT\", \"HKONT_OPP\", \"QSREC\", \"AUGBL\", \"AUGDT\", \"WT_QSZRT\", \"WT_WDMBTR\", \"WT_WWRBTR\", \"WT_WDMBT2\", \"WT_WDMBT3\", \"TEXT15\", \"WT_QBUIHH\", \"WT_QBUIHB\", \"WT_QBUIH2\", \"WT_QBUIH3\", \"WT_ACCBS\", \"WT_ACCWT\", \"WT_ACCWTA\", \"WT_ACCWTHA\", \"WT_ACCBS1\", \"WT_ACCWT1\", \"WT_ACCWTA1\", \"WT_ACCWTHA1\", \"WT_ACCBS2\", \"WT_ACCWT2\", \"WT_ACCWTA2\", \"WT_ACCWTHA2\", \"QSATZ\", \"WT_SLFWTPD\", \"WT_GRUWTPD\", \"WT_OPOWTPD\", \"WT_GIVENPD\", \"CTNUMBER\", \"WT_DOWNC\", \"WT_RESITEM\", \"CTISSUEDATE\", \"J_1BWHTCOLLCODE\", \"J_1BWHTRATE\", \"J_1BWHT_BS\", \"J_1BWHTACCBS\", \"J_1BWHTACCBS1\", \"J_1BWHTACCBS2\", \"J_1IINTCHLN\", \"J_1IINTCHDT\", \"J_1IEWTREC\", \"J_1IBUZEI\", \"J_1ICERTDT\", \"J_1ICLRAMT\", \"J_1IREBZG\", \"J_1ISURAMT\", \"J_1AF_WT_REPBS\", \"WT_CALC\", \"WT_LOGSYS\", \"_DATAAGING\", \"FIWTIN_PAR_EXEM\" FROM \"SAPPRD\".\"WITH_ITEM\";",
          "--final_file_name": "from_SAP/for_ingestion/with_item_output.json"
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
      "Next": "Load_WITH_ITEM"
    },
    "Load_WITH_ITEM": {
      "Comment": "Load SAPPRD.WITH_ITEM to Postgres",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "with_item",   
          "--input_file_name": "from_SAP/for_ingestion/with_item_output.json"
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
          "email_subject": "[SUCCESS] Daily ingestion of WITH_ITEM",
          "email_body": "✅ Processing Complete: Successfully synced S4HANA WITH_ITEM table."
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
          "email_subject": "[FAILED] Daily ingestion of WITH_ITEM",
          "email_body.$": "States.Format('❌ Processing Failed: Unexpected issue was encountered while processing. \n\nError: {}\n\nPlease check the cloudwatch logs for details.', $.glue_error.Cause)"
        }
      },
      "ResultPath": null,
      "End": true
    }
  }
}