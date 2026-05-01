variable "name" {
  description = "Name of the custom event bus."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]{1,256}$", var.name))
    error_message = "Bus name must be 1-256 characters and contain only alphanumerics, dots, underscores, and hyphens."
  }
}

variable "kms_key_identifier" {
  description = "KMS key id, alias, or ARN used to encrypt event data on the bus. Null uses AWS-managed encryption."
  type        = string
  default     = null
}

variable "rules" {
  description = "Map of EventBridge rules to create. Key is the logical id; value is `{ name, description (optional), event_pattern (JSON-encoded string), state (optional, ENABLED/DISABLED) }`."
  type = map(object({
    name          = string
    description   = optional(string)
    event_pattern = string
    state         = optional(string, "ENABLED")
  }))
  default = {}

  validation {
    condition     = alltrue([for r in var.rules : contains(["ENABLED", "DISABLED"], coalesce(r.state, "ENABLED"))])
    error_message = "rules[].state must be ENABLED or DISABLED."
  }
}

variable "targets" {
  description = "Map of EventBridge targets to create. Key is the logical id; value is `{ rule_key (matches a key in var.rules), target_id, arn, role_arn (optional), input (optional), input_path (optional), input_transformer (optional { input_paths = map, input_template = string }), dlq_arn (optional), retry_policy (optional { maximum_event_age_in_seconds, maximum_retry_attempts }) }`."
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags applied to the bus and rules."
  type        = map(string)
  default     = {}
}
