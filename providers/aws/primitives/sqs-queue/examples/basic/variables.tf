variable "name" {
  type        = string
  description = "The name of the SQS queue."
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "The visibility timeout for the queue in seconds."
  default     = 30
}

variable "message_retention_seconds" {
  type        = number
  description = "The number of seconds Amazon SQS retains a message."
  default     = 345600
}

variable "kms_key_description" {
  type        = string
  description = "Description for the KMS key used to encrypt the SQS queue."
  default     = "Customer-managed KMS key for SQS queue encryption"
}

variable "kms_key_deletion_window_in_days" {
  type        = number
  description = "Duration in days after which the key is deleted after destruction."
  default     = 7
}

variable "kms_key_enable_rotation" {
  type        = bool
  description = "Whether to enable automatic key rotation for the KMS key."
  default     = true
}

variable "enable_dlq" {
  type        = bool
  description = "Whether to create a dead-letter queue."
  default     = false
}

variable "dlq_name" {
  type        = string
  description = "The name of the dead-letter queue."
  default     = null
}

variable "max_receive_count" {
  type        = number
  description = "Number of times a message is received before being moved to the DLQ."
  default     = 5
}

variable "enable_dlq_alarm" {
  type        = bool
  description = "Whether to create a CloudWatch alarm for DLQ depth."
  default     = false
}

variable "dlq_alarm_name" {
  type        = string
  description = "The name of the CloudWatch alarm for DLQ depth."
  default     = null
}

variable "dlq_alarm_threshold" {
  type        = number
  description = "The threshold for the DLQ depth alarm."
  default     = 0
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
  default     = {}
}
