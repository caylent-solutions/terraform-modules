variable "name" {
  type        = string
  description = "Name for the DynamoDB table"
}

variable "hash_key" {
  type        = string
  description = "Attribute to use as the hash (partition) key"
  default     = "pk"
}

variable "hash_key_type" {
  type        = string
  description = "Attribute type for the hash key. Valid values: S, N, B"
  default     = "S"
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  description = "Whether to enable point-in-time recovery for the table"
  default     = true
}

variable "ttl_enabled" {
  type        = bool
  description = "Whether to enable time-to-live on the table"
  default     = false
}

variable "ttl_attribute_name" {
  type        = string
  description = "Name of the TTL attribute"
  default     = "ttl"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the DynamoDB table"
  default     = {}
}
