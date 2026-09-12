module "eventbridge_bss_bc_bt" {
  # source = "globe.pe.jfrog.io/hmd-terraform-local__service/aws-eventbridge/aws"
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "sap_to_s3"
  target_type = "stepfunctions"

  schedule_expression = "cron(0 13 6,8,10,11,13,16,18,21,24,27 * ? *)"
  targets = [{
      name = "bss_bc_gt",
      type = "stepfunctions"
  }]

}


module "eventbridge_bss_eom_gt" {
  # source = "globe.pe.jfrog.io/hmd-terraform-local__service/aws-eventbridge/aws"
  source = "./modules/aws-eventbridge"
 
  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }
  
  depends_on = [module.stepfunctions_bss_eom_gt]
 
  name = "bss_eom_gt"
  target_type = "stepfunctions"
  
  targets = [{
      name = "bss_eom_gt"
      type = "stepfunctions"
    }]
  
  schedule_expression = "cron(0 13 * * ? *)"
  step_functions      = "sf_bss_eom_gt"
 
 }
 