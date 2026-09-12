module "eventbridge_sap_to_s3" {
  # source = "globe.pe.jfrog.io/hmd-terraform-local__service/aws-eventbridge/aws"
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_s3]
  name = "sap_to_s3"
  target_type = "stepfunctions"

  schedule_expression = "cron(0 13 * * ? *)"
  targets = [{
        name = "sap_to_s3",
        type = "stepfunctions"
  }]
  
}