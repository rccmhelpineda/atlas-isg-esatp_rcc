data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  schedule = coalesce(var.schedule_expression_stepfunctions, var.schedule_expression)

  raw_target = (
    try(var.targets[0].name, null) != null && try(var.targets[0].name, "") != ""
    ? var.targets[0].name
    : (var.step_functions != null && var.step_functions != "" ? var.step_functions : var.name)
  )

  # HMD overlay uses {env_prefix}-{short}-sf. Stand-in SFN is {env_prefix}-{short}-sfn.
  short_name = trimsuffix(trimprefix(local.raw_target, "${var.env_prefix}-"), "-sf")

  sfn_lookup_name = "${var.env_prefix}-${local.short_name}-sfn"

  raw_input = try(var.targets[0].input, null)
  target_input = (
    local.raw_input == null
    ? jsonencode({ env_prefix = var.env_prefix })
    : try(tostring(local.raw_input), jsonencode(local.raw_input))
  )
}

resource "aws_cloudwatch_event_rule" "rule" {
  name                = "${var.env_prefix}-${var.name}-rule"
  description         = "Schedule for ${var.name}"
  schedule_expression = local.schedule
}

resource "aws_iam_role" "eventbridge_role" {
  name = "${var.env_prefix}-${var.name}-eb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "eventbridge_policy" {
  name = "${var.env_prefix}-${var.name}-eb-policy"
  role = aws_iam_role.eventbridge_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["states:StartExecution"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.rule.name
  target_id = "${var.env_prefix}-${var.name}-target"
  arn       = "arn:aws:states:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stateMachine:${local.sfn_lookup_name}"
  role_arn  = aws_iam_role.eventbridge_role.arn
  input     = local.target_input
}
