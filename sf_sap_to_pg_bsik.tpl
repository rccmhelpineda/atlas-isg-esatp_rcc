{
  "Comment": "SAP to S3 multi-query extract using a single sap_2_s3 Glue job",
  "StartAt": "Extract_BSIK",
  "States": {
    "Extract_BSIK": {
      "Comment": "Full extract of SAPPRD.BSIK",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "bsik",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"LIFNR\", \"UMSKS\", \"UMSKZ\", \"AUGDT\", \"AUGBL\", \"ZUONR\", \"GJAHR\", \"BELNR\", \"BUZEI\", \"BUDAT\", \"BLDAT\", \"CPUDT\", \"WAERS\", \"XBLNR\", \"BLART\", \"MONAT\", \"BSCHL\", \"ZUMSK\", \"SHKZG\", \"GSBER\", \"MWSKZ\", \"DMBTR\", \"WRBTR\", \"MWSTS\", \"WMWST\", \"BDIFF\", \"BDIF2\", \"SGTXT\", \"PROJN\", \"AUFNR\", \"ANLN1\", \"ANLN2\", \"EBELN\", \"EBELP\", \"SAKNR\", \"HKONT\", \"FKONT\", \"FILKD\", \"ZFBDT\", \"ZTERM\", \"ZBD1T\", \"ZBD2T\", \"ZBD3T\", \"ZBD1P\", \"ZBD2P\", \"SKFBT\", \"SKNTO\", \"WSKTO\", \"ZLSCH\", \"ZLSPR\", \"ZBFIX\", \"HBKID\", \"BVTYP\", \"REBZG\", \"REBZJ\", \"REBZZ\", \"SAMNR\", \"ZOLLT\", \"ZOLLD\", \"LZBKZ\", \"LANDL\", \"DIEKZ\", \"MANSP\", \"MSCHL\", \"MADAT\", \"MANST\", \"MABER\", \"XNETB\", \"XANET\", \"XCPDD\", \"XESRD\", \"XZAHL\", \"MWSK1\", \"DMBT1\", \"WRBT1\", \"MWSK2\", \"DMBT2\", \"WRBT2\", \"MWSK3\", \"DMBT3\", \"WRBT3\", \"QSSKZ\", \"QSSHB\", \"QBSHB\", \"BSTAT\", \"ANFBN\", \"ANFBJ\", \"ANFBU\", \"VBUND\", \"REBZT\", \"STCEG\", \"EGBLD\", \"EGLLD\", \"QSZNR\", \"QSFBT\", \"XINVE\", \"PROJK\", \"FIPOS\", \"NPLNR\", \"AUFPL\", \"APLZL\", \"XEGDR\", \"DMBE2\", \"DMBE3\", \"DMB21\", \"DMB22\", \"DMB23\", \"DMB31\", \"DMB32\", \"DMB33\", \"MWST2\", \"MWST3\", \"SKNT2\", \"SKNT3\", \"BDIF3\", \"XRAGL\", \"RSTGR\", \"UZAWE\", \"KOSTL\", \"LNRAN\", \"XSTOV\", \"KZBTR\", \"XREF1\", \"XREF2\", \"XARCH\", \"PSWSL\", \"PSWBT\", \"IMKEY\", \"ZEKKN\", \"FISTL\", \"GEBER\", \"DABRZ\", \"XNEGP\", \"EMPFB\", \"PRCTR\", \"XREF3\", \"DTWS1\", \"DTWS2\", \"DTWS3\", \"DTWS4\", \"XPYPR\", \"KIDNO\", \"PYCUR\", \"PYAMT\", \"BUPLA\", \"SECCO\", \"PPDIFF\", \"PPDIF2\", \"PPDIF3\", \"PENLC1\", \"PENLC2\", \"PENLC3\", \"PENFC\", \"PENDAYS\", \"PENRC\", \"VERTT\", \"VERTN\", \"VBEWA\", \"KBLNR\", \"KBLPOS\", \"GRANT_NBR\", \"GMVKZ\", \"SRTYPE\", \"LOTKZ\", \"ZINKZ\", \"FKBER\", \"INTRENO\", \"PPRCT\", \"BUZID\", \"AUGGJ\", \"HKTID\", \"BUDGET_PD\", \"_DATAAGING\", \"KONTT\", \"KONTL\", \"UEBGDAT\", \"VNAME\", \"EGRUP\", \"BTYPE\", \"PROPMANO\", \"GKONT\", \"GKART\", \"GHKON\" FROM \"SAPPRD\".\"BSIK\";",
          "--final_file_name": "from_SAP/for_ingestion/bsik_output.json"
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
      "Next": "Load_BSIK"
    },
    "Load_BSIK": {
      "Comment": "Load SAPPRD.BSIK to Postgres",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "bsik",   
          "--input_file_name": "from_SAP/for_ingestion/bsik_output.json"
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
          "email_subject": "[SUCCESS] Daily ingestion of BSIK",
          "email_body": "✅ Processing Complete: Successfully synced S4HANA BSIK table."
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
          "email_subject": "[FAILED] Daily ingestion of BSIK",
          "email_body.$": "States.Format('❌ Processing Failed: Unexpected issue was encountered while processing. \n\nError: {}\n\nPlease check the cloudwatch logs for details.', $.glue_error.Cause)"
        }
      },
      "ResultPath": null,
      "End": true
    }
  }
}