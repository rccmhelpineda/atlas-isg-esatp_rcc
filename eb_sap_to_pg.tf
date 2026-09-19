module "eventbridge_sap_to_pg_all_small" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_all_small]

  name = "s4_2_pgs_as"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_as-sf"

  schedule_expression_stepfunctions = "cron(30 14 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_as-sf"
    type = "stepfunctions"
    input = jsonencode({
        env_prefix = "${var.env_prefix}"
    })      
  }]
}

module "eventbridge_sap_to_pg_all_big" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_sap_to_pg_all_big]

  name = "s4_2_pgs_ab"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_ab-sf"

  schedule_expression_stepfunctions = "cron(0 18 * * ? *)"  #
  targets = [{
    name = "${var.env_prefix}-s4_2_pg_ab-sf",
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

  depends_on = [module.stepfunctions_sap_to_pg_all_small]

  name = "s4_2_pgs-2"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-s4_2_pg_as-sf"

  schedule_expression_stepfunctions = "cron(15 15 * * ? *)"
  targets = [{
      name = "${var.env_prefix}-s4_2_pg_as-sf",
      type = "stepfunctions"
      input = jsonencode({
          env_prefix = "${var.env_prefix}"
      })
  }]
}
