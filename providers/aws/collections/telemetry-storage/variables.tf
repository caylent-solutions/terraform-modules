# --- SQS queue (sqs-queue primitive) ----------------------------------------

variable "queue_name" {
  description = "Name of the primary ingest queue."
  type        = string
}

variable "queue_message_retention_seconds" {
  description = "Retention period for messages in the primary queue (seconds)."
  type        = number
  default     = 345600
}

variable "queue_visibility_timeout_seconds" {
  description = "Visibility timeout in seconds for the primary queue. Should exceed the consumer Lambda's timeout."
  type        = number
  default     = 60
}

variable "queue_receive_wait_time_seconds" {
  description = "Long-polling receive wait time (seconds). 0 disables long polling."
  type        = number
  default     = 20
}

variable "queue_delay_seconds" {
  description = "Delivery delay applied to all messages enqueued (seconds)."
  type        = number
  default     = 0
}

variable "queue_max_message_size" {
  description = "Maximum message size in bytes (1024 to 262144)."
  type        = number
  default     = 262144
}

variable "queue_kms_master_key_id" {
  description = "KMS CMK ARN or alias for SSE-KMS encryption. When null, the primitive falls back to SQS-managed SSE."
  type        = string
  default     = null
}

variable "queue_sqs_managed_sse_enabled" {
  description = "Enable SQS-managed server-side encryption when no KMS key is supplied."
  type        = bool
  default     = true
}

variable "queue_create_dlq" {
  description = "Whether to create the dead-letter queue and wire the primary queue's redrive policy at it."
  type        = bool
  default     = true
}

variable "queue_max_receive_count" {
  description = "maxReceiveCount on the redrive policy. After this many failed receives, messages move to the DLQ."
  type        = number
  default     = 5
}

variable "queue_dlq_message_retention_seconds" {
  description = "Retention period for messages in the dead-letter queue (seconds)."
  type        = number
  default     = 1209600
}

variable "queue_create_dlq_depth_alarm" {
  description = "Whether to create a CloudWatch alarm on the DLQ message-count metric."
  type        = bool
  default     = false
}

variable "queue_dlq_depth_alarm_threshold" {
  description = "DLQ depth alarm threshold (number of messages)."
  type        = number
  default     = 1
}

variable "queue_dlq_depth_alarm_actions" {
  description = "List of ARNs invoked when the DLQ depth alarm enters ALARM state (typically SNS topic ARNs)."
  type        = list(string)
  default     = []
}

variable "queue_dlq_depth_alarm_ok_actions" {
  description = "List of ARNs invoked when the DLQ depth alarm returns to OK state."
  type        = list(string)
  default     = []
}

# --- DynamoDB table (dynamodb-table primitive) ------------------------------

variable "table_name" {
  description = "Name of the DynamoDB table."
  type        = string
}

variable "table_billing_mode" {
  description = "Billing mode: PAY_PER_REQUEST or PROVISIONED."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "table_hash_key" {
  description = "Hash key (partition key) attribute name."
  type        = string
}

variable "table_range_key" {
  description = "Range key (sort key) attribute name. Null for tables without a sort key."
  type        = string
  default     = null
}

variable "table_attributes" {
  description = "Attribute definitions for keys and indexes. Each entry is `{ name, type }` (type = S, N, or B)."
  type = list(object({
    name = string
    type = string
  }))
}

variable "table_global_secondary_indexes" {
  description = "Global Secondary Indexes (see dynamodb-table primitive for full schema)."
  type        = any
  default     = []
}

variable "table_local_secondary_indexes" {
  description = "Local Secondary Indexes (see dynamodb-table primitive for full schema)."
  type        = any
  default     = []
}

variable "table_read_capacity" {
  description = "Provisioned read capacity (only used when billing_mode = PROVISIONED)."
  type        = number
  default     = 0
}

variable "table_write_capacity" {
  description = "Provisioned write capacity (only used when billing_mode = PROVISIONED)."
  type        = number
  default     = 0
}

variable "table_stream_enabled" {
  description = "Whether to enable DynamoDB Streams on the table."
  type        = bool
  default     = false
}

variable "table_stream_view_type" {
  description = "DynamoDB Streams view type when stream_enabled is true. One of NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES, KEYS_ONLY."
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

variable "table_class" {
  description = "Table class: STANDARD or STANDARD_INFREQUENT_ACCESS."
  type        = string
  default     = "STANDARD"
}

variable "table_ttl_attribute_name" {
  description = "Name of the attribute used for DynamoDB TTL. Null disables TTL."
  type        = string
  default     = null
}

variable "table_point_in_time_recovery_enabled" {
  description = "Whether to enable point-in-time recovery (PITR)."
  type        = bool
  default     = true
}

variable "table_deletion_protection_enabled" {
  description = "Whether to enable deletion protection on the table."
  type        = bool
  default     = false
}

variable "table_kms_key_arn" {
  description = "Customer-managed KMS CMK ARN used for encryption at rest. Null falls back to AWS-owned key."
  type        = string
  default     = null
}

# --- EventBridge bus (eventbridge-bus primitive) ----------------------------

variable "bus_name" {
  description = "Name of the EventBridge bus."
  type        = string
}

variable "bus_kms_key_identifier" {
  description = "KMS CMK identifier used to encrypt events at rest. Null uses the AWS-managed key."
  type        = string
  default     = null
}

variable "bus_rules" {
  description = "Map of EventBridge rules. See the eventbridge-bus primitive for the object schema."
  type = map(object({
    name          = string
    description   = optional(string)
    event_pattern = string
    state         = optional(string, "ENABLED")
  }))
  default = {}
}

variable "bus_targets" {
  description = "Map of EventBridge targets. See the eventbridge-bus primitive for the object schema."
  type        = any
  default     = {}
}

# --- Common -----------------------------------------------------------------

variable "tags" {
  description = "Tags applied to all module-managed resources."
  type        = map(string)
  default     = {}
}
