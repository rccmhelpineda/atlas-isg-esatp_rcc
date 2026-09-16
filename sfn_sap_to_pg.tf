data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "stepfunctions_sap_to_pg_all" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_all"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}


module "stepfunctions_sap_to_pg_bsak" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_bsak"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg_bsak.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_sap_to_pg_bsik" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_bsik"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg_bsik.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_sap_to_pg_bsid" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_bsid"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg_bsid.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_sap_to_pg_acdoca" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_acdo"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg_acdoca.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_sap_to_pg_dd03l" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_dd03"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg_dd03l.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_sap_to_pg_prps" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_prps"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg_prps.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_sap_to_pg_with_item" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_wi"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg_with_item.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}

module "stepfunctions_sap_to_pg_all_copy" {
  source = "./modules/aws-step-functions"

  providers = {
    aws.environment = aws.environment,
    aws.security    = aws.security
  }

  name                     = "s4_2_pg_a2"
  timeout_seconds          = 3600  # 1 hour max for all queries combined
  heartbeat_seconds        = 600   # 10 min heartbeat per Glue job step
  interval                 = 60
  max_attempts             = 2
  max_delay_seconds        = 120
  state_machine_definition = templatefile("sf_sap_to_pg_copy.tpl", {
    env_prefix     = var.env_prefix
    aws_region     = data.aws_region.current.name
    aws_account_id = data.aws_caller_identity.current.account_id
  })
}