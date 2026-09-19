{
  "Comment": "APRM Processing",
  "StartAt": "Extract_1",
  "States": {
    "Extract_1": {
      "Comment": "ICCBS BT : sap_bdef_USD.txt → sap_bdef_usd_ssis",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-iccbs_bt-gljo-extract_1',$.env_prefix)",
        "Arguments": {
        }
      },
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_2"
    },
    "Extract_2": {
      "Comment": "ICCBS BT : sap_bdef_PHP.txt → sap_bdef_php_ssis",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-iccbs_bt-gljo-extract_2',$.env_prefix)",
        "Arguments": {
        }
      },
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_3"
    },
    "Extract_3": {
      "Comment": "ICCBS BT : sap_blcb_USD.txt → sap_blcb_usd_ssis",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-iccbs_bt-gljo-extract_3',$.env_prefix)",
        "Arguments": {
        }
      },
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_4"
    },
    "Extract_4": {
      "Comment": "ICCBS BT : sap_blcb_PHP.txt → sap_blcb_php_ssis",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-iccbs_bt-gljo-extract_4',$.env_prefix)",
        "Arguments": {
        }
      },
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Extract_5"
    },
    "Extract_5": {
      "Comment": "ICCBS BT : sap_blcu_PHP.txt → sap_blcu_php_ssis",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-iccbs_bt-gljo-extract_5',$.env_prefix)",
        "Arguments": {
        }
      },
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
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
          "email_subject": "SUCCESS: AWS Glue Job Completed",
          "email_body": "Your automated Step Functions workflow finished successfully."
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
          "email_subject": "FAILED: AWS Glue Job Error",
          "email_body.$": "States.Format('Your Step Functions workflow failed. Error Details: {}', $.glue_error)"
        }
      },
      "ResultPath": null,
      "Next": "Fail"
    },

    "Fail": {
      "Type": "Fail",
      "Error": "BSS Bill Cycle Pipeline -  Bayantel",
      "Cause": "The Glue Job or processing step failed."
    }

  }
}