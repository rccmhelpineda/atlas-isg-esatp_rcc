{
  "Comment": "BSS Bill Cycle Run for Globe",
  "StartAt": "Extract_Manger",
  "States": {
    "Extract_Manger": {
      "Comment": "Start Extract Manger",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-extract_mgr',$.env_prefix)",
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
      "Next": "SAP_preload"
    },
    "SAP_preload": {
      "Comment": "sap_preload",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-sap_preload',$.env_prefix)",
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
      "Next": "Transform_1"
    },
    "Transform_1": {
      "Comment": "Transform 1",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-transform_1',$.env_prefix)",
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
      "Next": "Export_1a"
    },
    "Export_1a": {
      "Comment": "Export 1a",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_1a',$.env_prefix)",
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
      "Next": "Export_1b"
    },
    "Export_1b": {
      "Comment": "Export 1b",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_1b',$.env_prefix)",
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
      "Next": "Transform_2"
    },
    "Transform_2": {
      "Comment": "Transform 2",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-transform_2',$.env_prefix)",
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
      "Next": "Export_2a"
    },
    "Export_2a": {
      "Comment": "Export 2a",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_2a',$.env_prefix)",
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
      "Next": "Export_2b"
    },
    "Export_2b": {
      "Comment": "Export 2b",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_2b',$.env_prefix)",
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
      "Next": "Transform_3"
    },
    "Transform_3": {
      "Comment": "Transform 3",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-transform_3',$.env_prefix)",
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
      "Next": "Export_3a"
    },
    "Export_3a": {
      "Comment": "Export 3a",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_3a',$.env_prefix)",
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
      "Next": "Export_3b"
    },
    "Export_3b": {
      "Comment": "Export 3b",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_3b',$.env_prefix)",
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
      "Next": "Transform_4"
    },
    "Transform_4": {
      "Comment": "Transform 4",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-transform_4',$.env_prefix)",
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
      "Next": "Export_4a"
    },
    "Export_4a": {
      "Comment": "Export 4a",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_4a',$.env_prefix)",
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
      "Next": "Export_4b"
    },
    "Export_4b": {
      "Comment": "Export 4b",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_4b',$.env_prefix)",
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
      "Next": "Export_4c"
    },
    "Export_4c": {
      "Comment": "Export 4c",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_4c',$.env_prefix)",
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
      "Next": "Transform_5"
    },
    "Transform_5": {
      "Comment": "Transform 5",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-transform_5',$.env_prefix)",
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
      "Next": "Export_5a"
    },
    "Export_5a": {
      "Comment": "Export Preparation",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_5a',$.env_prefix)",
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
      "Next": "Export_5b"
    },
    "Export_5b": {
      "Comment": "Export 5b",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-mybss_gt_eom-gljo-export_5b',$.env_prefix)",
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
        "StateMachineArn": "States.Format('arn:aws:states:{}:{}:stateMachine:{}-notifier-sf','${aws_region}','${aws_account_id}',$.env_prefix)"
        "Input": {
          "email_subject": "[SUCCESS] MyBSS Mothend Processig - Globe ",
          "email_body": "✅ Processing Complete: Your data has been successfully processed and the result file is ready for review."
        }
      },
      "End": true
    },

    "Notify_Fail": {
      "Type": "Task",
      "Resource": "arn:aws:states:::states:startExecution",
      "Parameters": {
        "StateMachineArn": "States.Format('arn:aws:states:{}:{}:stateMachine:{}-notifier-sf','${aws_region}','${aws_account_id}',$.env_prefix)"
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