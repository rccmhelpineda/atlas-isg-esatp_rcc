{
  "Comment": "BSS Bill Cycle Run for Bayan",
  "StartAt": "Extract_1",
  "States": {
    "Extract_1": {
      "Comment": "Extract 308. Billed Adjustments Monthly Summary Report",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-etl_mybss-gljo-extract_1',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC",
          "--input_file_name.$": "States.Format('308. Billed Adjustments Monthly Summary Report_B_{}.xlsx',$.BCNUM)",
          "--target_table.$": "States.Format('sdbtdir2_bayan_dbo.308_Billed_Adjustments_{}',$.BCNUM)"
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
      "Comment": "Extract 318. Billed Charges Summary Report.XLSX",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-etl_mybss-gljo-extract_2',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC",
          "--input_file_name.$": "States.Format('318. Billed Charges Summary Report_B_{}.XLSX',$.BCNUM)",
          "--target_table.$": "States.Format('sdbtdir2_bayan_dbo.318_Billed_Charges_{}',$.BCNUM)"
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
      "Comment": "Extract 411. Bill Control_PHP.XLSX",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-etl_mybss-gljo-extract_3',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC",
          "--input_file_name.$": "States.Format('411. Bill Control_PHP_B_{}.XLSX',$.BCNUM)",
          "--target_table.$": "States.Format('sdbtdir2_bayan_dbo.411_Bill_Control_PHP_{}',$.BCNUM)"
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
      "Comment": "Extract 411. Bill Control_USD.XLSX",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-etl_mybss-gljo-extract_4',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC",
          "--target_table.$": "States.Format('sdbtdir2_bayan_dbo.411_Bill_Control_USD_{}',$.BCNUM)",
          "--input_file_name.$": "States.Format('411. Bill Control_USD_B_{}.XLSX',$.BCNUM)"
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
      "Comment": "Extract sap_glbilled.txt",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-etl_mybss-gljo-extract_5',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC",
          "--target_table.$": "States.Format('sdbtdir2_bayan_dbo.sap_glbilled_{}',$.BCNUM)",
          "--input_file_name.$": "States.Format('sap_glbilled_B_{}.txt',$.BCNUM)"
        }
      },
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
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
        "JobName.$": "States.Format('{}-etl_mybss-gljo-sap_preload',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC"
        }
      },
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Transform"
    },
    "Transform": {
      "Comment": "Transform",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-etl_mybss-gljo-transform',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC"
        }
      },
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Export_prep"
    },
    "Export_prep": {
      "Comment": "Export Preparation",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-etl_mybss-gljo-export_prep',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC"
        }
      },
      "Catch": [
        {
          "ErrorEquals": ["States.ALL"],
          "ResultPath": "$.glue_error",
          "Next": "Notify_Fail"
        }
      ],
      "Next": "Export"
    },
    "Export": {
      "Comment": "Export",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName.$": "States.Format('{}-etl_mybss-gljo-export',$.env_prefix)",
        "Arguments": {
          "--CODE.$": "$.CODE",
          "--BCNUM.$": "$.BCNUM",
          "--BC.$": "$.BC",
          "--EXPORT.$": "States.Format('txBayan_Billed_{}_LoadFileSel.txt',$.CODE)"
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