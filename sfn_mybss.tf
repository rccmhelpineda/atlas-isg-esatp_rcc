module "stepfunctions_bss_bc_bt" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "bss_bc_bt"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_mybss_bc_bt.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_bss_bc_gt" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "bss_bc_gt"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_mybss_bc_gt.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_bss_bc_ic" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "bss_bc_ic"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_mybss_bc_ic.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_bss_eom_bt" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "bss_eom_bt"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_mybss_eom_bt.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_bss_eom_gt" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "bss_eom_gt"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_mybss_eom_gt.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_bss_eom_ic" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "bss_eom_ic"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_mybss_eom_ic.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}
