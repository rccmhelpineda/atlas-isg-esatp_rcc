{
  "Comment": "APRM Processing",
  "StartAt": "extract_mgr",
  "States": {
    "extract_mgr": {
      "Comment": "Extract 308. Billed Adjustments Monthly Summary Report",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-iccbs_ic-gljo-extract_mgr',$.env_prefix)",
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