variable "table_name" {
  description = "Base name of the table (a random suffix is appended for test isolation)."
  type        = string
}

variable "billing_mode" {
  description = "Billing mode."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Partition key attribute name."
  type        = string
}

variable "range_key" {
  description = "Sort key attribute name (optional)."
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of attribute definitions."
  type = list(object({
    name = string
    type = string
  }))
}

variable "global_secondary_indexes" {
  description = "Global Secondary Indexes."
  type        = any
  default     = []
}

variable "stream_enabled" {
  description = "Enable DynamoDB Streams."
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Stream view type."
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

variable "ttl_attribute_name" {
  description = "TTL attribute name (null disables)."
  type        = string
  default     = null
}

variable "point_in_time_recovery_enabled" {
  description = "Enable PITR."
  type        = bool
  default     = true
}

variable "deletion_protection_enabled" {
  description = "Enable deletion protection."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the table."
  type        = map(string)
  default     = {}
}
