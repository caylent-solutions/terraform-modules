variable "name" {
  type        = string
  description = "Friendly name of the Secrets Manager secret."
  default     = "telemetry-basic-secret"
}

variable "description" {
  type        = string
  description = "Description of the secret."
  default     = "Basic example secret for secrets-manager-secret module"
}

variable "recovery_window_in_days" {
  type        = number
  description = "Number of days before the secret can be permanently deleted."
  default     = 7
}

variable "enable_rotation" {
  type        = bool
  description = "Whether to enable automatic rotation."
  default     = false
}

variable "rotation_lambda_arn" {
  type        = string
  description = "ARN of the Lambda function that rotates the secret."
  default     = null
}

variable "rotation_days" {
  type        = number
  description = "Number of days between automatic rotations."
  default     = 90
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
  default = {
    Environment = "test"
    Purpose     = "secrets-manager-secret-module-testing"
    Owner       = "terraform"
  }
}
