{
  "Comment": "This Replaced Old SSIS MyBss_Globe_Unconfirmed_Advance_MSF.dtsx",
  "StartAt": "MyBSS_Extract_8",
  "States": {
    "MyBSS_Extract_8": {
      "Comment": "This is about populating table 'sdbTDIR2_Globe.Unconfirmed_Advanced_MSF_Charges'",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-extract_8',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC"
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
      "Next": "MyBSS_Extract_9"
    },
    "MyBSS_Extract_9": {
      "Comment": "This is about populating table 'sdbTDIR2_Globe.DP5_Unconfirmed_Advance_MSF_header",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-extract_9',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC"
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
      "Error": "BSS End of Month Pipeline -  Globe",
      "Cause": "The Glue Job or processing step failed."
    }

 } 
}