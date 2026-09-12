variable "name" {
  type        = string
  description = "Bucket component name (e.g. storage, scripts)"
}

variable "allow_iam_admin" {
  type        = list(string)
  default     = []
}

variable "lifecycle_rules" {
  type    = any
  default = []
}
