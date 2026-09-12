variable "name" {
  type        = string
  description = "Component name / prefix"
}

variable "s3_bucket_name" {
  type        = list(string)
  description = "Bucket names"
  default     = []
}

variable "sns_topic_name" {
  type        = string
  description = "SNS topic name"
  default     = null
}

variable "glue_database" {
  type = list(object({
    name = string
  }))
  default = []
}

variable "source_secrets_manager_arn" {
  type        = string
  default     = null
}

variable "source_secrets_manager_name" {
  type        = string
  default     = null
}

variable "source_secrets_manager_kms_key_arn" {
  type        = string
  default     = "*"
}

variable "glue_connections" {
  type = any
  default = []
}

variable "security_configurations" {
  type = any
  default = []
}

variable "glue_jobs" {
  type = any
  default = []
}

variable "glue_role_name" {
  type        = string
  default     = "CustomRole_Glue-S3-AuroraPG"
  description = "IAM execution role for Glue"
}
