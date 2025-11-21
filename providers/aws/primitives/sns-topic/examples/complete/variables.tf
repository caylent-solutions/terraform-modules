variable "name" {
  description = "The name of the SNS topic."
  type        = string
}

variable "display_name" {
  description = "The display name for the topic"
  type        = string
  default     = null
}

variable "signature_version" {
  description = "The signature version corresponds to the hashing algorithm used (1 or 2)"
  type        = string
  default     = "1"
}

variable "tracing_config" {
  description = "Tracing mode for the topic (PassThrough or Active)"
  type        = string
  default     = null
}

variable "kms_master_key_id" {
  description = "The ID or ARN of a customer-managed KMS key for SNS encryption."
  type        = string
  default     = null
}

variable "policy" {
  description = "The fully-formed AWS policy as JSON for the SNS topic"
  type        = string
  default     = null
}

variable "enable_delivery_status_logging" {
  description = "Enable delivery status logging for all subscription types"
  type        = bool
  default     = false
}

variable "lambda_success_feedback_role_arn" {
  description = "IAM role ARN for successful Lambda deliveries"
  type        = string
  default     = null
}

variable "lambda_failure_feedback_role_arn" {
  description = "IAM role ARN for failed Lambda deliveries"
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Percentage of successful Lambda deliveries to log (0-100)"
  type        = number
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the topic."
  type        = map(string)
  default     = {}
}
