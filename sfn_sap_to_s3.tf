module "stepfunctions_sap_to_s3" {
  # source = "globe.pe.jfrog.io/hmd-terraform-local__service/aws-step-functions/aws"
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "sap_to_s3"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = file("sf_sap_to_s3.tpl")
}
