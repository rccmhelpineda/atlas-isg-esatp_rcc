variable "name" {
  type        = string
  description = "Rule name (HMD component short name)"
}

variable "target_type" {
  type        = string
  default     = "stepfunctions"
}

variable "schedule_expression" {
  type        = string
  default     = null
  description = "Sandbox-style cron/rate. Prefer schedule_expression_stepfunctions for WORA copies of client eb_*.tf."
}

variable "schedule_expression_stepfunctions" {
  type        = string
  default     = null
  description = "HMD client argument name for the EventBridge schedule."
}

variable "targets" {
  type    = any
  default = []
}

variable "step_functions" {
  type        = string
  default     = null
  description = "HMD full SFN name, e.g. {env_prefix}-bss_bc_gt-sf"
}

variable "glue_enabled" {
  type    = bool
  default = false
}

variable "lambda_enabled" {
  type    = bool
  default = false
}

variable "env_prefix" {
  type        = string
  default     = "isg-esatp-dv"
  description = "Not passed from eb_*.tf (WORA). Used to map HMD -sf names to stand-in -sfn names."
}
