output "arn" {
  description = "ARN of the Step Function State Machine"
  value       = aws_sfn_state_machine.sfn.arn
}

output "name" {
  description = "Name of the Step Function State Machine"
  value       = aws_sfn_state_machine.sfn.name
}
