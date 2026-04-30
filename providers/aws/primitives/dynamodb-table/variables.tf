variable "name" {
  description = "Name of the DynamoDB table. Maximum 255 chars per AWS limit."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{3,255}$", var.name))
    error_message = "Table name must be 3-255 characters and contain only alphanumerics, underscores, dots, and hyphens."
  }
}

variable "billing_mode" {
  description = "Billing mode: PAY_PER_REQUEST (on-demand) or PROVISIONED. Provisioned requires read_capacity / write_capacity (and optional autoscaling)."
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED."
  }

  validation {
    condition     = !(var.billing_mode == "PROVISIONED") || (var.read_capacity > 0 && var.write_capacity > 0)
    error_message = "When billing_mode = PROVISIONED, both read_capacity and write_capacity must be > 0."
  }
}

variable "hash_key" {
  description = "Partition key attribute name. The matching attribute must be present in var.attributes."
  type        = string
}

variable "range_key" {
  description = "Optional sort key attribute name. When set, the matching attribute must be present in var.attributes."
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of attribute definitions for keys and indexes. Each attribute is `{ name = string, type = \"S\"|\"N\"|\"B\" }`. Required because every key referenced by `hash_key`, `range_key`, GSI, or LSI must have a matching attribute definition."
  type = list(object({
    name = string
    type = string
  }))

  validation {
    condition     = length(var.attributes) >= 1
    error_message = "attributes must contain at least the partition key (hash_key) attribute definition."
  }

  validation {
    condition     = alltrue([for a in var.attributes : contains(["S", "N", "B"], a.type)])
    error_message = "Every attribute type must be one of S (string), N (number), or B (binary)."
  }

  validation {
    condition     = contains([for a in var.attributes : a.name], var.hash_key)
    error_message = "var.attributes must contain a definition for the hash_key attribute."
  }

  validation {
    condition     = var.range_key == null || contains([for a in var.attributes : a.name], coalesce(var.range_key, ""))
    error_message = "var.attributes must contain a definition for the range_key attribute when range_key is set."
  }
}

variable "global_secondary_indexes" {
  description = "Global Secondary Indexes. Each entry: { name, hash_key, range_key (optional), projection_type (KEYS_ONLY|INCLUDE|ALL), non_key_attributes (optional list, required when projection_type = INCLUDE), read_capacity (optional, PROVISIONED only), write_capacity (optional, PROVISIONED only) }."
  type        = any
  default     = []
}

variable "local_secondary_indexes" {
  description = "Local Secondary Indexes. Each entry: { name, range_key, projection_type (KEYS_ONLY|INCLUDE|ALL), non_key_attributes (optional list, required when projection_type = INCLUDE) }. LSIs require range_key on the table (enforced by cross-variable validation)."
  type        = any
  default     = []

  validation {
    condition     = length(var.local_secondary_indexes) == 0 || var.range_key != null
    error_message = "local_secondary_indexes requires var.range_key to be set on the table (LSIs are defined relative to the primary sort key)."
  }
}

variable "read_capacity" {
  description = "Provisioned read capacity units (only used when billing_mode = PROVISIONED)."
  type        = number
  default     = 0

  validation {
    condition     = var.read_capacity >= 0
    error_message = "read_capacity must be >= 0."
  }
}

variable "write_capacity" {
  description = "Provisioned write capacity units (only used when billing_mode = PROVISIONED)."
  type        = number
  default     = 0

  validation {
    condition     = var.write_capacity >= 0
    error_message = "write_capacity must be >= 0."
  }
}

variable "stream_enabled" {
  description = "Whether DynamoDB Streams are enabled."
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Stream view type when stream_enabled = true. One of NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES, KEYS_ONLY."
  type        = string
  default     = "NEW_AND_OLD_IMAGES"

  validation {
    condition     = contains(["NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES", "KEYS_ONLY"], var.stream_view_type)
    error_message = "stream_view_type must be one of NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES, KEYS_ONLY."
  }
}

variable "table_class" {
  description = "Storage class: STANDARD or STANDARD_INFREQUENT_ACCESS."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_class)
    error_message = "table_class must be STANDARD or STANDARD_INFREQUENT_ACCESS."
  }
}

variable "deletion_protection_enabled" {
  description = "Enable deletion protection on the table."
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "Attribute name to use for TTL. When null, TTL is disabled. The attribute must contain a Unix epoch (seconds) value."
  type        = string
  default     = null
}

variable "point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery (PITR). Recommended for production tables."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN of the customer-managed KMS key used for server-side encryption. When null, AWS-owned KMS is used."
  type        = string
  default     = null
}

variable "autoscaling_enabled" {
  description = "Enable Application Auto Scaling on the table's read/write capacity. PROVISIONED billing only."
  type        = bool
  default     = false

  validation {
    condition     = !(var.autoscaling_enabled) || var.billing_mode == "PROVISIONED"
    error_message = "autoscaling_enabled = true requires billing_mode = PROVISIONED."
  }
}

variable "autoscaling_target_utilization" {
  description = "Target utilization percentage for the table-level read/write autoscaling policies."
  type        = number
  default     = 70

  validation {
    condition     = var.autoscaling_target_utilization > 0 && var.autoscaling_target_utilization <= 100
    error_message = "autoscaling_target_utilization must be > 0 and <= 100."
  }
}

variable "autoscaling_read_min_capacity" {
  description = "Minimum read capacity when autoscaling_enabled = true."
  type        = number
  default     = 5

  validation {
    condition     = var.autoscaling_read_min_capacity >= 1
    error_message = "autoscaling_read_min_capacity must be >= 1."
  }
}

variable "autoscaling_read_max_capacity" {
  description = "Maximum read capacity when autoscaling_enabled = true."
  type        = number
  default     = 100

  validation {
    condition     = var.autoscaling_read_max_capacity >= 1
    error_message = "autoscaling_read_max_capacity must be >= 1."
  }

  validation {
    condition     = var.autoscaling_read_max_capacity >= var.autoscaling_read_min_capacity
    error_message = "autoscaling_read_max_capacity must be >= autoscaling_read_min_capacity (Application Auto Scaling rejects max < min at apply time)."
  }
}

variable "autoscaling_write_min_capacity" {
  description = "Minimum write capacity when autoscaling_enabled = true."
  type        = number
  default     = 5

  validation {
    condition     = var.autoscaling_write_min_capacity >= 1
    error_message = "autoscaling_write_min_capacity must be >= 1."
  }
}

variable "autoscaling_write_max_capacity" {
  description = "Maximum write capacity when autoscaling_enabled = true."
  type        = number
  default     = 100

  validation {
    condition     = var.autoscaling_write_max_capacity >= 1
    error_message = "autoscaling_write_max_capacity must be >= 1."
  }

  validation {
    condition     = var.autoscaling_write_max_capacity >= var.autoscaling_write_min_capacity
    error_message = "autoscaling_write_max_capacity must be >= autoscaling_write_min_capacity (Application Auto Scaling rejects max < min at apply time)."
  }
}

variable "tags" {
  description = "Tags applied to the table (and to autoscaling resources via inheritance from the table)."
  type        = map(string)
  default     = {}
}
