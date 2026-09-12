variable "name" {
  type        = string
  description = "State machine name"
}

variable "state_machine_definition" {
  type        = string
  description = "JSON state machine definition"
}

variable "timeout_seconds" {
  type        = number
  default     = 3600
}

variable "heartbeat_seconds" {
  type        = number
  default     = 600
}

variable "interval" {
  type        = number
  default     = 60
}

variable "max_attempts" {
  type        = number
  default     = 2
}

variable "max_delay_seconds" {
  type        = number
  default     = 120
}
