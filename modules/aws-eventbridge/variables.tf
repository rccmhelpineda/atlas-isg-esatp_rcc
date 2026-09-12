variable "name" {
  type        = string
  description = "Rule name"
}

variable "target_type" {
  type        = string
  default     = "stepfunctions"
}

variable "schedule_expression" {
  type        = string
  description = "Cron or rate expression"
}

variable "targets" {
  type = any
  default = []
}

variable "step_functions" {
  type        = string
  default     = null
}
