variable "name" {
  description = "Name of the cost anomaly detector"
  type        = string
}

variable "monitor_type" {
  description = "Type of monitor (DIMENSIONAL or CUSTOM)"
  type        = string
  default     = "DIMENSIONAL"
  validation {
    condition     = contains(["DIMENSIONAL", "CUSTOM"], var.monitor_type)
    error_message = "Monitor type must be either DIMENSIONAL or CUSTOM."
  }
}



variable "monitor_dimension" {
  description = "Dimension for DIMENSIONAL monitor type (SERVICE, LINKED_ACCOUNT, etc.)"
  type        = string
  default     = "SERVICE"
  validation {
    condition = contains([
      "SERVICE", "LINKED_ACCOUNT", "AZ", "INSTANCE_TYPE", "REGION", "PURCHASE_TYPE", "TENANCY", "PLATFORM"
    ], var.monitor_dimension)
    error_message = "Monitor dimension must be a valid AWS Cost Explorer dimension."
  }
}

variable "monitor_specification" {
  description = "JSON specification for CUSTOM monitor type"
  type        = string
  default     = null
}

variable "monitor_name" {
  description = "Name of the cost anomaly monitor"
  type        = string
  default     = null
}

variable "create_subscription" {
  description = "Whether to create a cost anomaly subscription"
  type        = bool
  default     = true
}

variable "subscription_name" {
  description = "Name of the cost anomaly subscription"
  type        = string
  default     = null
}

variable "subscription_frequency" {
  description = "Frequency of subscription notifications"
  type        = string
  default     = "DAILY"
  validation {
    condition     = contains(["DAILY", "IMMEDIATE", "WEEKLY"], var.subscription_frequency)
    error_message = "Subscription frequency must be DAILY, IMMEDIATE, or WEEKLY."
  }
}



variable "subscribers" {
  description = "List of subscribers for anomaly notifications"
  type = list(object({
    type    = string
    address = string
  }))
  default = []
}

variable "threshold_amount" {
  description = "Threshold amount for anomaly alerts (in USD)"
  type        = number
  default     = 100
}

variable "threshold_key" {
  description = "Threshold key for anomaly detection"
  type        = string
  default     = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
  validation {
    condition = contains([
      "ANOMALY_TOTAL_IMPACT_ABSOLUTE",
      "ANOMALY_TOTAL_IMPACT_PERCENTAGE"
    ], var.threshold_key)
    error_message = "Threshold key must be ANOMALY_TOTAL_IMPACT_ABSOLUTE or ANOMALY_TOTAL_IMPACT_PERCENTAGE."
  }
}

variable "threshold_match_options" {
  description = "Match options for threshold"
  type        = list(string)
  default     = ["GREATER_THAN_OR_EQUAL"]
  validation {
    condition = alltrue([
      for option in var.threshold_match_options :
      contains(["EQUALS", "GREATER_THAN_OR_EQUAL", "LESS_THAN_OR_EQUAL"], option)
    ])
    error_message = "Match options must be EQUALS, GREATER_THAN_OR_EQUAL, or LESS_THAN_OR_EQUAL."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

