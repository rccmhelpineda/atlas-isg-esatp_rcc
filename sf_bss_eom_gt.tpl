{
    "Comment": "This Replaced Old SSIS MyBss_Globe_Unconfirmed_Advance_MSF.dtsx",
    "StartAt": "MyBSS_Globe_EOM_Extract_SSIS_Unconfirmed_Advance_MSF_Part1",
    "States": {
        "MyBSS_Globe_EOM_Extract_SSIS_Unconfirmed_Advance_MSF_Part1": {
            "Comment": "This is about populating table 'sdbTDIR2_Globe.Unconfirmed_Advanced_MSF_Charges'",
            "Type": "Task",
            "Resource": "arn:aws:states:::glue:startJobRun.sync",
            "Parameters": {
                "JobName": "isg-esatp-dv-bss_eom_glob_preload_extract-glue_Unconfirmed_Advanced_MSF_Charges"
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
            "Next": "MyBSS_Globe_EOM_Extract_SSIS_Unconfirmed_Advance_MSF_Part2"
        },
        "MyBSS_Globe_EOM_Extract_SSIS_Unconfirmed_Advance_MSF_Part2": {
            "Comment": "This is about populating table 'sdbTDIR2_Globe.DP5_Unconfirmed_Advance_MSF_header",
            "Type": "Task",
            "Resource": "arn:aws:states:::glue:startJobRun.sync",
            "Parameters": {
                "JobName": "isg-esatp-dv-bss_eom_glob_preload_extract-glue_DP5_Unconfirmed_Advance_MSF_header"
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
                "FunctionName": "arn:aws:lambda:us-east-1:979437352248:function:Isg-esatp-dv-error_parser-lambda",
                "Payload": {
                    "raw_cause.$": "$.glue_error.Cause"
                }
            },
            "ResultSelector": {
                "cleaned_cause.$": "$.Payload.cleaned_cause"
            },
            "ResultPath": "$.clean_error_payload",
            "Next": "MyBSS_Globe_EOM_Pipeline-ERROR"
        },
        "MyBSS_Globe_EOM_Pipeline-ERROR": {
            "Type": "Fail",
            "Error": "PipelineJobFailed",
            "CausePath": "$.clean_error_payload.cleaned_cause"
        }
    }
}