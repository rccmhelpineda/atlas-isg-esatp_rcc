data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "stepfunctions_sap_to_pg_all_small" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_as"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg_small_2.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_sap_to_pg_all_big" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_ab"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg_big_2.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}
