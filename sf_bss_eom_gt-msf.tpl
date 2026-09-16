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
          "email_subject": "[SUCCESS] MyBSS Bill Cycle - Innove ",
          "email_body": "✅ Processing Complete: Your data has been successfully processed and the result file is ready for review."
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
          "email_subject": "[FAILED] MyBSS Monthend Processing - Globe ",
          "email_body.$": "States.Format('❌ Processing Failed: Unexpected issue was encountered while processing. \n\nError: {}\n\nPlease check the cloudwatch logs for details.', $.glue_error.Cause)"
        }
      },
      "ResultPath": null,
      "End": true
    }
 } 
}