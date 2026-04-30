variable "queue_name" {
  description = "Base name of the queue (a random suffix is appended for test isolation)."
  type        = string
}

variable "fifo_queue" {
  description = "Whether to create a FIFO queue."
  type        = bool
  default     = false
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds."
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "Message retention in seconds."
  type        = number
  default     = 345600
}

variable "receive_wait_time_seconds" {
  description = "Long-polling wait time in seconds."
  type        = number
  default     = 0
}

variable "create_dlq" {
  description = "Whether to create the DLQ + redrive policy."
  type        = bool
  default     = true
}

variable "max_receive_count" {
  description = "Max receive count before redrive to DLQ."
  type        = number
  default     = 5
}

variable "create_dlq_depth_alarm" {
  description = "Whether to create a CloudWatch alarm on DLQ depth (an SNS topic is provisioned alongside)."
  type        = bool
  default     = true
}

variable "dlq_depth_alarm_threshold" {
  description = "Number of DLQ messages at which the alarm transitions to ALARM."
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
