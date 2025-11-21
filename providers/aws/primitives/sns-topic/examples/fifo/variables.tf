variable "name" {
  description = "The name of the SNS topic."
  type        = string
}

variable "fifo_topic" {
  description = "Boolean indicating whether or not to create a FIFO topic"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO topics"
  type        = bool
  default     = false
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

variable "tags" {
  description = "A map of tags to assign to the topic."
  type        = map(string)
  default     = {}
}
