module "eventbridge_sap_to_pg_all" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_all]

  name = "s4_2_pgs"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_all-sf"

  schedule_expression_stepfunctions = "cron(0 23 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_all-sf",
    type = "stepfunctions"
    input = jsonencode({
        env_prefix = "${var.env_prefix}",
    })
  }]

}

module "eventbridge_sap_to_pg_bsak" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_bsak]

  name = "s4_pgs_bsak"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_bsak-sf"

  schedule_expression_stepfunctions = "cron(0 11 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_bsak-sf",
    type = "stepfunctions"
    input = jsonencode({
        env_prefix = "${var.env_prefix}"
      })
  }]
}

module "eventbridge_sap_to_pg_bsik" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_bsik]

  name = "s4_pgs_bsik"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_bsik-sf"
  
  schedule_expression_stepfunctions = "cron(30 18 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_bsik-sf",
    type = "stepfunctions"
    input = jsonencode({
        env_prefix = "${var.env_prefix}"
      })
  }]
}

module "eventbridge_sap_to_pg_bsid" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_bsid]

  name = "s4_pgs_bsid"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_bsid-sf"

  schedule_expression_stepfunctions = "cron(0 19 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_bsid-sf",
    type = "stepfunctions"
    input = jsonencode({
        env_prefix = "${var.env_prefix}"
      })
  }]
}

module "eventbridge_sap_to_pg_acdo" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_bsid]

  name = "s4_pgs_acdo"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_acdo-sf"

  schedule_expression_stepfunctions = "cron(30 19 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_acdo-sf",
    type = "stepfunctions"
    input = jsonencode({
        env_prefix = "${var.env_prefix}"
      })
  }]
}

module "eventbridge_sap_to_pg_dd03" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_bsid]

  name = "s4_pgs_dd03"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_dd03-sf"

  schedule_expression_stepfunctions = "cron(0 20 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_dd03-sf",
    type = "stepfunctions"
    input = jsonencode({
        env_prefix = "${var.env_prefix}"
      })
  }]
}

module "eventbridge_sap_to_pg_prps" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_bsid]

  name = "s4_pgs_prps"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_prps-sf"

  schedule_expression_stepfunctions = "cron(30 20 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_prps-sf",
    type = "stepfunctions"
    input = jsonencode({
        env_prefix = "${var.env_prefix}"
      })
  }]
}

module "eventbridge_sap_to_pg_wi" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_bsid]

  name = "s4_pgs_wi"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_wi-sf"

  schedule_expression_stepfunctions = "cron(00 21 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_wi-sf",
    type = "stepfunctions"
    input = jsonencode({
        env_prefix = "${var.env_prefix}"
      })
  }]
}

module "eventbridge_sap_to_pg_all_copy" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_all_copy]

  name = "s4_2_pgs_all"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_a2-sf"

  schedule_expression_stepfunctions = "cron(35 7 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_a2-sf",
    type = "stepfunctions"
    input = jsonencode({
        env_prefix = "${var.env_prefix}"
      })
  }]
}

module "eventbridge_sap_to_pg_test" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_all]

  name = "s4_2_pgs-2"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_all-sf"
  
  schedule_expression_stepfunctions = "cron(15 15 * * ? *)"  
  targets = [{
      name = "${var.env_prefix}-s4_2_pg_all-sf",
      type = "stepfunctions"
  }]
}
