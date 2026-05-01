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
  description = "Map of EventBridge targets to create. Key is the logical id; value is a typed object describing the target. `rule_key` MUST match a key in `var.rules` (validated cross-variable). `input`, `input_path`, and `input_transformer` are mutually exclusive at AWS-side; consumers should set only one."
  type = map(object({
    rule_key   = string
    target_id  = string
    arn        = string
    role_arn   = optional(string)
    input      = optional(string)
    input_path = optional(string)
    input_transformer = optional(object({
      input_paths    = optional(map(string))
      input_template = string
    }))
    dlq_arn = optional(string)
    retry_policy = optional(object({
      maximum_event_age_in_seconds = number
      maximum_retry_attempts       = number
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for t in var.targets : contains(keys(var.rules), t.rule_key)])
    error_message = "Every targets[].rule_key must reference a key defined in var.rules."
  }
}

variable "tags" {
  description = "Tags applied to the bus and rules."
  type        = map(string)
  default     = {}
}
