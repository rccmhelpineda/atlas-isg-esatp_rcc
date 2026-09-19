module "stepfunctions_iccbs_bt" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "iccbs_bt"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_iccbs_bt.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_iccbs_ic" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "iccbs_ic"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_iccbs_ic.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}
