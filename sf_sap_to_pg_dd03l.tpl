{
  "Comment": "SAP to S3 multi-query extract using a single sap_2_s3 Glue job",
  "StartAt": "Extract_DD03L",
  "States": {
    "Extract_DD03L": {
      "Comment": "Full extract of SAPPRD.DD03L",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-sap_to_s3-gljo-sap_2_s3',$.env_prefix)",
        "Arguments": {
          "--table_name": "dd03l",
          "--query": "SELECT \"FIELDNAME\", \"AS4LOCAL\", \"AS4VERS\", \"POSITION\", \"KEYFLAG\", \"MANDATORY\", \"ROLLNAME\", \"CHECKTABLE\", \"ADMINFIELD\", \"INTTYPE\", \"INTLEN\", \"REFTABLE\", \"PRECFIELD\", \"REFFIELD\", \"CONROUT\", \"NOTNULL\", \"DATATYPE\", \"LENG\", \"DECIMALS\", \"DOMNAME\", \"SHLPORIGIN\", \"TABLETYPE\", \"DEPTH\", \"COMPTYPE\", \"REFTYPE\", \"LANGUFLAG\", \"DBPOSITION\", \"ANONYMOUS\", \"OUTPUTSTYLE\" FROM \"SAPPRD\".\"DD03L\";",
          "--final_file_name": "from_SAP/for_ingestion/dd03l_output.json"
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
      "Next": "Load_DD03L"
    },
    "Load_DD03L": {
      "Comment": "Load SAPPRD.DD03L to Postgres",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-s3_to_pg-gljo-s3_to_pg',$.env_prefix)",
        "Arguments": {
          "--s4_table_name": "dd03l",   
          "--input_file_name": "from_SAP/for_ingestion/dd03l_output.json"
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
          "email_subject": "[SUCCESS] Daily ingestion of DD03L",
          "email_body": "✅ Processing Complete: Successfully synced S4HANA DD03L table."
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
          "email_subject": "[FAILED] Daily ingestion of DD03L",
          "email_body.$": "States.Format('❌ Processing Failed: Unexpected issue was encountered while processing. \n\nError: {}\n\nPlease check the cloudwatch logs for details.', $.glue_error.Cause)"
        }
      },
      "ResultPath": null,
      "End": true
    }
  }
}