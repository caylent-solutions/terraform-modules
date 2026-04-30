variable "name" {
  description = "Name of the secret. The full ARN appends a random 6-character suffix that AWS reserves for each secret."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9/_+=.@!-]{1,512}$", var.name))
    error_message = "Secret name must be 1-512 characters from the AWS-allowed set (alphanumerics and /_+=.@!-)."
  }
}

variable "description" {
  description = "Description of the secret."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS key id, alias name, alias ARN, or key ARN used to encrypt the secret. When null, the AWS-managed key `aws/secretsmanager` is used."
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before deleting a secret on destroy. 0 forces immediate deletion (no recovery); 7-30 enables a recovery window."
  type        = number
  default     = 30

  validation {
    condition     = var.recovery_window_in_days == 0 || (var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30)
    error_message = "recovery_window_in_days must be 0 (immediate delete) or 7-30 (recovery window)."
  }
}

variable "replica_regions" {
  description = "List of replica region configurations: `[{ region, kms_key_id (optional) }, ...]`. Empty list disables replication."
  type = list(object({
    region     = string
    kms_key_id = optional(string)
  }))
  default = []
}

variable "initial_secret_string" {
  description = "Initial secret value as a plain string. Null skips creating the initial version (consumers populate via SDK or another resource). Treat as sensitive when set."
  type        = string
  default     = null
  sensitive   = true
}

variable "rotation_lambda_arn" {
  description = "ARN of an existing Lambda function used to rotate the secret. Null disables managed rotation."
  type        = string
  default     = null
}

variable "rotation_automatically_after_days" {
  description = "Rotation cadence in days. Per spec/security.md the default is 90 days."
  type        = number
  default     = 90

  validation {
    condition     = var.rotation_automatically_after_days >= 1 && var.rotation_automatically_after_days <= 365
    error_message = "rotation_automatically_after_days must be 1-365."
  }
}

variable "resource_policy_json" {
  description = "Optional resource-based policy attached to the secret. Provide a JSON-encoded string. Null skips attaching a resource policy."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the secret."
  type        = map(string)
  default     = {}
}
