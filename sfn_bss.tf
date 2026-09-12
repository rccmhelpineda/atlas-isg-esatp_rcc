module "stepfunctions_bss_bc_bt" {
  # source = "globe.pe.jfrog.io/hmd-terraform-local__service/aws-step-functions/aws"
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

   name               = "bss_bc_bt"
   timeout_seconds    = 300
   heartbeat_seconds  = 300
   interval           = 100
   max_attempts       = 1
   max_delay_seconds  = 60
   state_machine_definition = file("sf_bss_bc_bt.tpl")
}

module "stepfunctions_bss_eom_gt" {
  # source = "globe.pe.jfrog.io/hmd-terraform-local__service/aws-step-functions/aws"
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

   name               = "bss_eom_gt"
   timeout_seconds    = 300
   heartbeat_seconds  = 300
   interval           = 100
   max_attempts       = 1
   max_delay_seconds  = 60
   state_machine_definition = file("sf_bss_eom_gt.tpl")
}
