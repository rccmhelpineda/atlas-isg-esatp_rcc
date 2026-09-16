{
  "Comment": "SAP to S3 multi-query extract using a single sap_2_s3 Glue job",
  "StartAt": "Extract_BSID",
  "States": {
    "Extract_BSID": {
      "Comment": "Full extract of SAPPRD.BSID",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "bsid",
          "--query": "SELECT \"MANDT\", \"BUKRS\", \"KUNNR\", \"UMSKS\", \"UMSKZ\", \"AUGDT\", \"AUGBL\", \"ZUONR\", \"GJAHR\", \"BELNR\", \"BUZEI\", \"BUDAT\", \"BLDAT\", \"CPUDT\", \"WAERS\", \"XBLNR\", \"BLART\", \"MONAT\", \"BSCHL\", \"ZUMSK\", \"SHKZG\", \"GSBER\", \"MWSKZ\", \"DMBTR\", \"WRBTR\", \"MWSTS\", \"WMWST\", \"BDIFF\", \"BDIF2\", \"SGTXT\", \"PROJN\", \"AUFNR\", \"ANLN1\", \"ANLN2\", \"SAKNR\", \"HKONT\", \"FKONT\", \"FILKD\", \"ZFBDT\", \"ZTERM\", \"ZBD1T\", \"ZBD2T\", \"ZBD3T\", \"ZBD1P\", \"ZBD2P\", \"SKFBT\", \"SKNTO\", \"WSKTO\", \"ZLSCH\", \"ZLSPR\", \"ZBFIX\", \"HBKID\", \"BVTYP\", \"REBZG\", \"REBZJ\", \"REBZZ\", \"SAMNR\", \"ANFBN\", \"ANFBJ\", \"ANFBU\", \"ANFAE\", \"MANSP\", \"MSCHL\", \"MADAT\", \"MANST\", \"MABER\", \"XNETB\", \"XANET\", \"XCPDD\", \"XINVE\", \"XZAHL\", \"MWSK1\", \"DMBT1\", \"WRBT1\", \"MWSK2\", \"DMBT2\", \"WRBT2\", \"MWSK3\", \"DMBT3\", \"WRBT3\", \"BSTAT\", \"VBUND\", \"VBELN\", \"REBZT\", \"INFAE\", \"STCEG\", \"EGBLD\", \"EGLLD\", \"RSTGR\", \"XNOZA\", \"VERTT\", \"VERTN\", \"VBEWA\", \"WVERW\", \"PROJK\", \"FIPOS\", \"NPLNR\", \"AUFPL\", \"APLZL\", \"XEGDR\", \"DMBE2\", \"DMBE3\", \"DMB21\", \"DMB22\", \"DMB23\", \"DMB31\", \"DMB32\", \"DMB33\", \"BDIF3\", \"XRAGL\", \"UZAWE\", \"XSTOV\", \"MWST2\", \"MWST3\", \"SKNT2\", \"SKNT3\", \"XREF1\", \"XREF2\", \"XARCH\", \"PSWSL\", \"PSWBT\", \"LZBKZ\", \"LANDL\", \"IMKEY\", \"VBEL2\", \"VPOS2\", \"POSN2\", \"ETEN2\", \"FISTL\", \"GEBER\", \"DABRZ\", \"XNEGP\", \"KOSTL\", \"RFZEI\", \"KKBER\", \"EMPFB\", \"PRCTR\", \"XREF3\", \"QSSKZ\", \"ZINKZ\", \"DTWS1\", \"DTWS2\", \"DTWS3\", \"DTWS4\", \"XPYPR\", \"KIDNO\", \"ABSBT\", \"CCBTC\", \"PYCUR\", \"PYAMT\", \"BUPLA\", \"SECCO\", \"CESSION_KZ\", \"PPDIFF\", \"PPDIF2\", \"PPDIF3\", \"KBLNR\", \"KBLPOS\", \"GRANT_NBR\", \"GMVKZ\", \"SRTYPE\", \"LOTKZ\", \"FKBER\", \"INTRENO\", \"PPRCT\", \"BUZID\", \"AUGGJ\", \"HKTID\", \"BUDGET_PD\", \"PAYS_PROV\", \"PAYS_TRAN\", \"MNDID\", \"_DATAAGING\", \"KONTT\", \"KONTL\", \"UEBGDAT\", \"VNAME\", \"EGRUP\", \"BTYPE\", \"PROPMANO\", \"GKONT\", \"GKART\", \"GHKON\" FROM \"SAPPRD\".\"BSID\";",
          "--final_file_name": "from_SAP/for_ingestion/bsid_output.json"
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
      "Next": "Load_BSID"
    },
    "Load_BSID": {
      "Comment": "Load SAPPRD.BSID to Postgres",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
        "Parameters": {
          "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
          "Arguments": {
            "--s4_table_name": "bsid",   
            "--input_file_name": "from_SAP/for_ingestion/bsid_output.json"
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
          "email_subject": "[SUCCESS] Daily ingestion of BSID",
          "email_body": "✅ Processing Complete: Successfully synced S4HANA BSID table."
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
          "email_subject": "[FAILED] Daily ingestion of BSID",
          "email_body.$": "States.Format('❌ Processing Failed: Unexpected issue was encountered while processing. \n\nError: {}\n\nPlease check the cloudwatch logs for details.', $.glue_error.Cause)"
        }
      },
      "ResultPath": null,
      "End": true
    }
  }
}