variable "name" {
  description = "Base name of the SQS queue. For FIFO queues, the module appends `.fifo`. The DLQ (when enabled) is named `<name>-dlq` (or `<name>-dlq.fifo`)."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,75}$", var.name))
    error_message = "Queue name must be 1-75 characters and contain only alphanumerics, hyphens, and underscores."
  }
}

variable "fifo_queue" {
  description = "Whether to create a FIFO queue. FIFO queues append `.fifo` to the queue name and accept content_based_deduplication."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "FIFO-only: enable content-based deduplication so the SHA-256 of the message body is used as the deduplication ID."
  type        = bool
  default     = false
}

variable "delay_seconds" {
  description = "Time in seconds that the delivery of all messages in the queue is delayed (0-900)."
  type        = number
  default     = 0

  validation {
    condition     = var.delay_seconds >= 0 && var.delay_seconds <= 900
    error_message = "delay_seconds must be between 0 and 900 inclusive."
  }
}

variable "max_message_size" {
  description = "Maximum message size in bytes (1024-262144)."
  type        = number
  default     = 262144

  validation {
    condition     = var.max_message_size >= 1024 && var.max_message_size <= 262144
    error_message = "max_message_size must be between 1024 and 262144 inclusive."
  }
}

variable "message_retention_seconds" {
  description = "Number of seconds the queue retains a message (60-1209600). AWS default is 4 days; 14 days is the maximum."
  type        = number
  default     = 345600

  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "message_retention_seconds must be between 60 and 1209600 inclusive."
  }
}

variable "receive_wait_time_seconds" {
  description = "Long-polling wait time in seconds (0-20). 0 disables long polling."
  type        = number
  default     = 0

  validation {
    condition     = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20
    error_message = "receive_wait_time_seconds must be between 0 and 20 inclusive."
  }
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds (0-43200). Should match the maximum processing time of the consumer."
  type        = number
  default     = 30

  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "visibility_timeout_seconds must be between 0 and 43200 inclusive."
  }
}

variable "kms_master_key_id" {
  description = "ARN or alias of the KMS CMK used for server-side encryption. When set, sqs_managed_sse_enabled is forced off (mutually exclusive)."
  type        = string
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "Length of time in seconds for which Amazon SQS can reuse a data key (60-86400). Only applied when kms_master_key_id is set."
  type        = number
  default     = 300

  validation {
    condition     = var.kms_data_key_reuse_period_seconds >= 60 && var.kms_data_key_reuse_period_seconds <= 86400
    error_message = "kms_data_key_reuse_period_seconds must be between 60 and 86400 inclusive."
  }
}

variable "sqs_managed_sse_enabled" {
  description = "Use AWS-managed SQS encryption (SSE-SQS). Only applied when kms_master_key_id is null."
  type        = bool
  default     = true
}

variable "create_dlq" {
  description = "Whether to create a dead-letter queue and a redrive policy on the primary queue."
  type        = bool
  default     = true
}

variable "max_receive_count" {
  description = "Maximum number of times a message is received before being routed to the DLQ. Only used when create_dlq = true."
  type        = number
  default     = 5

  validation {
    condition     = var.max_receive_count >= 1 && var.max_receive_count <= 1000
    error_message = "max_receive_count must be between 1 and 1000 inclusive."
  }
}

variable "dlq_message_retention_seconds" {
  description = "Number of seconds the DLQ retains a message (60-1209600). Defaults to 14 days for forensic investigation. Only used when create_dlq = true."
  type        = number
  default     = 1209600

  validation {
    condition     = var.dlq_message_retention_seconds >= 60 && var.dlq_message_retention_seconds <= 1209600
    error_message = "dlq_message_retention_seconds must be between 60 and 1209600 inclusive."
  }
}

variable "create_dlq_depth_alarm" {
  description = "Whether to create a CloudWatch alarm on the DLQ's ApproximateNumberOfMessagesVisible metric. Requires create_dlq = true."
  type        = bool
  default     = false
}

variable "dlq_depth_alarm_threshold" {
  description = "Number of DLQ messages at which the alarm transitions to ALARM."
  type        = number
  default     = 1

  validation {
    condition     = var.dlq_depth_alarm_threshold >= 1
    error_message = "dlq_depth_alarm_threshold must be >= 1."
  }
}

variable "dlq_depth_alarm_evaluation_periods" {
  description = "Number of periods over which to evaluate the alarm metric."
  type        = number
  default     = 1

  validation {
    condition     = var.dlq_depth_alarm_evaluation_periods >= 1
    error_message = "dlq_depth_alarm_evaluation_periods must be >= 1."
  }
}

variable "dlq_depth_alarm_period_seconds" {
  description = "Period in seconds over which the metric is aggregated."
  type        = number
  default     = 60

  validation {
    condition     = contains([10, 30, 60, 300, 900, 3600, 21600, 86400], var.dlq_depth_alarm_period_seconds)
    error_message = "dlq_depth_alarm_period_seconds must be one of 10, 30, 60, 300, 900, 3600, 21600, 86400."
  }
}

variable "dlq_depth_alarm_actions" {
  description = "ARNs to notify when the DLQ depth alarm enters ALARM state (typically SNS topics)."
  type        = list(string)
  default     = []
}

variable "dlq_depth_alarm_ok_actions" {
  description = "ARNs to notify when the DLQ depth alarm returns to OK state."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to the queue, DLQ (when created), and CloudWatch alarm (when created)."
  type        = map(string)
  default     = {}
}
