variable "name" {
  type        = string
  description = "(Required) Friendly name of the new secret. Must be unique within your AWS account and region."

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 512
    error_message = "Secret name must be between 1 and 512 characters."
  }
}

variable "description" {
  type        = string
  description = "(Optional) Description of the secret."
  default     = null
}

variable "kms_key_id" {
  type        = string
  description = "(Required) ARN or ID of the AWS KMS key used to encrypt the secret. All secrets must be encrypted at rest."
}

variable "recovery_window_in_days" {
  type        = number
  description = "(Optional) Number of days AWS Secrets Manager waits before it can delete the secret. Must be 0 (force delete) or between 7 and 30. Defaults to 30."
  default     = 30

  validation {
    condition     = var.recovery_window_in_days == 0 || (var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30)
    error_message = "recovery_window_in_days must be 0 (force delete) or between 7 and 30."
  }
}

variable "enable_rotation" {
  type        = bool
  description = "(Optional) Whether to enable automatic rotation for this secret. Requires rotation_lambda_arn when true. Defaults to false."
  default     = false
}

variable "rotation_lambda_arn" {
  type        = string
  description = "(Optional) ARN of the Lambda function that performs rotation. Required when enable_rotation is true."
  default     = null

  validation {
    condition     = var.rotation_lambda_arn == null || can(regex("^arn:aws[a-z-]*:lambda:[a-z0-9-]+:[0-9]{12}:function:.+$", var.rotation_lambda_arn))
    error_message = "rotation_lambda_arn must be a valid Lambda function ARN when provided."
  }
}

variable "rotation_days" {
  type        = number
  description = "(Optional) Number of days between automatic scheduled rotations. Must be between 1 and 365. Defaults to 90 per security policy."
  default     = 90

  validation {
    condition     = var.rotation_days >= 1 && var.rotation_days <= 365
    error_message = "rotation_days must be between 1 and 365."
  }
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A map of tags to assign to the secret."
  default     = {}
}

variable "managed_by_tag" {
  type        = string
  description = "(Optional) Value for the ManagedBy tag."
  default     = "terraform"
}

variable "module_tag" {
  type        = string
  description = "(Optional) Value for the Module tag."
  default     = "secrets-manager-secret"
}

