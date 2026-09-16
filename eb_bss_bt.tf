##########  BAYANTEL ######## 
module "eventbridge_bss_bc_bt_1" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc1_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 12 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC1",
        BCNUM = "1",
        BC    = "BC01"
        env_prefix = "${var.env_prefix}"
      })
  }]
}

module "eventbridge_bss_bc_bt_2" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc6_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 14 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC2",
        BCNUM = "6",
        BC    = "BC06"
        env_prefix = "${var.env_prefix}"
      })
 
  }]
}

module "eventbridge_bss_bc_bt_3" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc8_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 15 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC3",
        BCNUM = "8",
        BC    = "BC08"
        env_prefix = "${var.env_prefix}"
      })

  }]
}

module "eventbridge_bss_bc_bt_4" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc10_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 16 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC4",
        BCNUM = "10",
        BC    = "BC10"
        env_prefix = "${var.env_prefix}"
      })      
  }]
}

module "eventbridge_bss_bc_bt_5" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc11_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 17 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC5",
        BCNUM = "11",
        BC    = "BC11"
        env_prefix = "${var.env_prefix}"
      })      
  }]
}

module "eventbridge_bss_bc_bt_6" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc13_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 19 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC6",
        BCNUM = "13",
        BC    = "BC13"
        env_prefix = "${var.env_prefix}"
      })      
  }]
}

module "eventbridge_bss_bc_bt_7" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc16_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 21 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC7",
        BCNUM = "16",
        BC    = "BC16"
        env_prefix = "${var.env_prefix}"
      })      
  }]
}

module "eventbridge_bss_bc_bt_8" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc18_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 24 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC8",
        BCNUM = "18",
        BC    = "BC18"
        env_prefix = "${var.env_prefix}"
      })      
  }]
}

module "eventbridge_bss_bc_bt_9" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc21_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 26 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC9",
        BCNUM = "21",
        BC    = "BC21"
        env_prefix = "${var.env_prefix}"
      })      
  }]
}

module "eventbridge_bss_bc_bt_10" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc24_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 30 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC10",
        BCNUM = "24",
        BC    = "BC24"
        env_prefix = "${var.env_prefix}"
      })      
  }]
}

module "eventbridge_bss_bc_bt_11" {
  source = "./modules/aws-eventbridge"

  providers = {
    aws.environment = aws.environment
    aws.security    = aws.security
  }

  depends_on = [module.stepfunctions_bss_bc_bt]
  name = "bss_bc27_bt"
  target_type = "stepfunctions"
  step_functions = "${var.env_prefix}-bss_bc_bt-sf"

  schedule_expression_stepfunctions = "cron(40 7 2 * ? *)"
  targets = [{
      name = "${var.env_prefix}-bss_bc_bt-sf",
      type = "stepfunctions",
      input = jsonencode({
        CODE  = "EOC11",
        BCNUM = "27",
        BC    = "BC27"
        env_prefix = "${var.env_prefix}"
      })      
  }]
}

