resource "aws_cloudwatch_event_rule" "rule" {
  name                = "isg-esatp-dv-${var.name}-rule"
  description         = "Schedule for ${var.name}"
  schedule_expression = var.schedule_expression
}

resource "aws_iam_role" "eventbridge_role" {
  name = "isg-esatp-dv-${var.name}-eb-role"

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
  name = "isg-esatp-dv-${var.name}-eb-policy"
  role = aws_iam_role.eventbridge_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "states:StartExecution"
        ]
        Resource = "*"
      }
    ]
  })
}

locals {
  target_name = length(var.targets) > 0 ? var.targets[0].name : (var.step_functions != null ? var.step_functions : var.name)
}

data "aws_sfn_state_machine" "target" {
  name = "isg-esatp-dv-${local.target_name}-sfn"
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.rule.name
  target_id = "isg-esatp-dv-${var.name}-target"
  arn       = data.aws_sfn_state_machine.target.arn
  role_arn  = aws_iam_role.eventbridge_role.arn
}
