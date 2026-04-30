variable "name" {
  type        = string
  description = "(Required) The name of the SQS queue."
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "(Optional) The visibility timeout for the queue, in seconds. Defaults to 30."
  default     = 30
  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "visibility_timeout_seconds must be between 0 and 43200."
  }
}

variable "message_retention_seconds" {
  type        = number
  description = "(Optional) The number of seconds Amazon SQS retains a message. Defaults to 345600 (4 days)."
  default     = 345600
  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "message_retention_seconds must be between 60 and 1209600."
  }
}

variable "max_message_size" {
  type        = number
  description = "(Optional) The limit of how many bytes a message can contain. Defaults to 262144 (256 KiB)."
  default     = 262144
  validation {
    condition     = var.max_message_size >= 1024 && var.max_message_size <= 262144
    error_message = "max_message_size must be between 1024 and 262144."
  }
}

variable "delay_seconds" {
  type        = number
  description = "(Optional) The time in seconds that the delivery of all messages in the queue will be delayed. Defaults to 0."
  default     = 0
  validation {
    condition     = var.delay_seconds >= 0 && var.delay_seconds <= 900
    error_message = "delay_seconds must be between 0 and 900."
  }
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "(Optional) The time for which a ReceiveMessage call will wait for a message to arrive. Defaults to 0 (short polling)."
  default     = 0
  validation {
    condition     = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20
    error_message = "receive_wait_time_seconds must be between 0 and 20."
  }
}

variable "kms_master_key_id" {
  type        = string
  description = "(Required) The ID or ARN of a customer-managed KMS key for SQS queue encryption. Must be a customer-managed key, not the AWS-managed SQS key."
}

variable "kms_data_key_reuse_period_seconds" {
  type        = number
  description = "(Optional) The length of time, in seconds, for which Amazon SQS can reuse a data key. Defaults to 300."
  default     = 300
  validation {
    condition     = var.kms_data_key_reuse_period_seconds >= 60 && var.kms_data_key_reuse_period_seconds <= 86400
    error_message = "kms_data_key_reuse_period_seconds must be between 60 and 86400."
  }
}

variable "enable_dlq" {
  type        = bool
  description = "(Optional) Whether to create a dead-letter queue for the main queue. Defaults to false."
  default     = false
}

variable "dlq_name" {
  type        = string
  description = "(Optional) The name of the dead-letter queue. Required when enable_dlq is true."
  default     = null
  validation {
    condition     = !var.enable_dlq || var.dlq_name != null
    error_message = "dlq_name must be set when enable_dlq is true."
  }
}

variable "dlq_message_retention_seconds" {
  type        = number
  description = "(Optional) The number of seconds the DLQ retains a message. Defaults to 1209600 (14 days)."
  default     = 1209600
  validation {
    condition     = var.dlq_message_retention_seconds >= 60 && var.dlq_message_retention_seconds <= 1209600
    error_message = "dlq_message_retention_seconds must be between 60 and 1209600."
  }
}

variable "max_receive_count" {
  type        = number
  description = "(Optional) The number of times a message is received before being moved to the DLQ. Defaults to 5."
  default     = 5
  validation {
    condition     = var.max_receive_count >= 1 && var.max_receive_count <= 1000
    error_message = "max_receive_count must be between 1 and 1000."
  }
}

variable "enable_dlq_alarm" {
  type        = bool
  description = "(Optional) Whether to create a CloudWatch alarm for DLQ depth. Requires enable_dlq to be true. Defaults to false."
  default     = false
}

variable "dlq_alarm_name" {
  type        = string
  description = "(Optional) The name of the CloudWatch alarm for DLQ depth. Required when enable_dlq_alarm is true."
  default     = null
  validation {
    condition     = !var.enable_dlq_alarm || var.dlq_alarm_name != null
    error_message = "dlq_alarm_name must be set when enable_dlq_alarm is true."
  }
}

variable "dlq_alarm_threshold" {
  type        = number
  description = "(Optional) The threshold for the DLQ depth alarm. Defaults to 0 (alarm on any message)."
  default     = 0
}

variable "dlq_alarm_evaluation_periods" {
  type        = number
  description = "(Optional) The number of periods to evaluate for the DLQ depth alarm. Defaults to 1."
  default     = 1
}

variable "dlq_alarm_period_seconds" {
  type        = number
  description = "(Optional) The period in seconds for the DLQ depth alarm metric. Defaults to 60."
  default     = 60
}

variable "dlq_alarm_actions" {
  type        = list(string)
  description = "(Optional) The list of ARNs to notify when the DLQ depth alarm transitions to ALARM state."
  default     = []
}

variable "dlq_alarm_ok_actions" {
  type        = list(string)
  description = "(Optional) The list of ARNs to notify when the DLQ depth alarm transitions to OK state."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A map of tags to assign to all resources."
  default     = {}
}

variable "dlq_alarm_comparison_operator" {
  type        = string
  description = "(Optional) The comparison operator for the DLQ depth alarm. Defaults to GreaterThanThreshold."
  default     = "GreaterThanThreshold"
  validation {
    condition = contains([
      "GreaterThanOrEqualToThreshold",
      "GreaterThanThreshold",
      "LessThanThreshold",
      "LessThanOrEqualToThreshold",
    ], var.dlq_alarm_comparison_operator)
    error_message = "dlq_alarm_comparison_operator must be one of: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  }
}

variable "dlq_alarm_metric_name" {
  type        = string
  description = "(Optional) The name of the CloudWatch metric for the DLQ depth alarm. Defaults to ApproximateNumberOfMessagesVisible."
  default     = "ApproximateNumberOfMessagesVisible"
}

variable "dlq_alarm_namespace" {
  type        = string
  description = "(Optional) The CloudWatch namespace for the DLQ depth alarm metric. Defaults to AWS/SQS."
  default     = "AWS/SQS"
}

variable "dlq_alarm_statistic" {
  type        = string
  description = "(Optional) The statistic to apply to the DLQ depth alarm metric. Defaults to Sum."
  default     = "Sum"
  validation {
    condition     = contains(["SampleCount", "Average", "Sum", "Minimum", "Maximum"], var.dlq_alarm_statistic)
    error_message = "dlq_alarm_statistic must be one of: SampleCount, Average, Sum, Minimum, Maximum."
  }
}

variable "dlq_alarm_description" {
  type        = string
  description = "(Optional) Description for the DLQ depth CloudWatch alarm."
  default     = "Dead-letter queue depth alarm"
}

variable "managed_by_tag" {
  type        = string
  description = "(Optional) Value for the ManagedBy tag."
  default     = "terraform"
}

variable "module_tag" {
  type        = string
  description = "(Optional) Value for the Module tag."
  default     = "sqs-queue"
}
