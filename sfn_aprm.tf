module "stepfunctions_aprm_acc_bt" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "aprm_acc_bt"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_aprm_acc_bt.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_aprm_acc_gt" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "aprm_acc_gt"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_aprm_acc_gt.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_aprm_acc_ic" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "aprm_acc_ic"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_aprm_acc_ic.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_aprm_del_bt" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "aprm_del_bt"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_aprm_del_bt.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_aprm_del_gt" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "aprm_del_gt"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_aprm_del_gt.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_aprm_del_ic" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "aprm_del_ic"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_aprm_del_ic.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_aprm_acc" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "aprm_acc"
  timeout_seconds          = 300
  heartbeat_seconds        = 300
  interval                 = 100
  max_attempts             = 2
  max_delay_seconds        = 60
  state_machine_definition = templatefile("sf_aprm_acc.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}
