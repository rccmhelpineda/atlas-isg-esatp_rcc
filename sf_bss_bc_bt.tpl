{
  "Comment": "SAP to S3 multi-query extract using a single sap_2_s3 Glue job",
  "StartAt": "Extract_Manger",
  "States": {
    "Extract_Manger": {
      "Comment": "Full extract of SAPPRD.AUFK",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "isg-esatp-dv-etl_mybss-gljo-extract_mgr",
        "Arguments": {
          "--BCDAY.$": "States.ArrayGetItem(States.StringSplit(States.ArrayGetItem(States.StringSplit($$.Execution.StartTime, 'T'), 0), '-'), 2)"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Parse_Glue_Error_Lambda"
        }
      ],
      "Next": "SAP_preload"
    },
    "SAP_preload": {
      "Comment": "sap_preload",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "isg-esatp-dv-etl_mybss-gljo-sap_preload",
        "Arguments": {
          "--BCDAY.$": "States.ArrayGetItem(States.StringSplit(States.ArrayGetItem(States.StringSplit($$.Execution.StartTime, 'T'), 0), '-'), 2)"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Parse_Glue_Error_Lambda"
        }
      ],
      "Next": "Transform"
    },
    "Transform": {
      "Comment": "Transform",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "isg-esatp-dv-etl_mybss-gljo-transform",
        "Arguments": {
          "--BCDAY.$": "States.ArrayGetItem(States.StringSplit(States.ArrayGetItem(States.StringSplit($$.Execution.StartTime, 'T'), 0), '-'), 2)"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Parse_Glue_Error_Lambda"
        }
      ],
      "Next": "Export_prep"
    },
    "Export_prep": {
      "Comment": "Export Preparation",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "isg-esatp-dv-etl_mybss-gljo-export_prep",
        "Arguments": {
          "--BCDAY.$": "States.ArrayGetItem(States.StringSplit(States.ArrayGetItem(States.StringSplit($$.Execution.StartTime, 'T'), 0), '-'), 2)"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Parse_Glue_Error_Lambda"
        }
      ],
      "Next": "Export"
    },
    "Export": {
      "Comment": "Export",
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "isg-esatp-dv-etl_mybss-gljo-export",
        "Arguments": {
          "--BCDAY.$": "States.ArrayGetItem(States.StringSplit(States.ArrayGetItem(States.StringSplit($$.Execution.StartTime, 'T'), 0), '-'), 2)"
        }
      },
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "ResultPath": "$.glue_error",
          "Next": "Parse_Glue_Error_Lambda"
        }
      ],
      "End": true
    },
    "Parse_Glue_Error_Lambda": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "arn:aws:lambda:ap-southeast-1:782221581292:function:isg-esatp-dv-error_parser-lambda",
        "Payload": {
          "raw_cause.$": "$.glue_error.Cause"
        }
      },
      "ResultSelector": {
        "cleaned_cause.$": "$.Payload.cleaned_cause"
      },
      "ResultPath": "$.clean_error_payload",
      "Next": "SAP_Extract_Pipeline_ERROR"
    },
    "SAP_Extract_Pipeline_ERROR": {
      "Type": "Fail",
      "Error": "PipelineJobFailed",
      "CausePath": "$.clean_error_payload.cleaned_cause"
    }
  }
}