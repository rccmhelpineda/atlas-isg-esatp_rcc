{
  "Comment": "APRM Processing - Innove",
  "StartAt": "Extract_1",
  "States": {
    "Extract_1": {
      "Comment": "APRM ACCRUAL Innove : ICEXT_GLB_A_VOICE.txt → sdbtdir3_aprm_dbo.icext_inv_a_voice",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-aprm_acc_ic-gljo-extract_1',$.env_prefix)",
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
      "Comment": "APRM ACCRUAL Innove : ICEXT_INV_A_VOICE_OUTPUT.TXT → sdbtdir3_aprm_dbo.icext_inv_a_voice_output",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-aprm_acc_ic-gljo-extract_2',$.env_prefix)",
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
      "Comment": "APRM ACCRUAL Innove : SAP_REPORT_INV_ACCRUAL.CSV → sdbtdir3_aprm_dbo.sap_report_inv_accrual",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-aprm_acc_ic-gljo-extract_3',$.env_prefix)",
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
      "Error": "APRM Processing -  Bayantel",
      "Cause": "The Glue Job or processing step failed."
    }

  }
}