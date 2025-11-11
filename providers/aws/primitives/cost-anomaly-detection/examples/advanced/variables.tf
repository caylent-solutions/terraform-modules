variable "name" {
  description = "Name of the cost anomaly detector"
  type        = string
  default     = "advanced-cost-anomaly-detector"
}

variable "monitor_type" {
  description = "Type of monitor"
  type        = string
  default     = "DIMENSIONAL"
}



variable "subscription_frequency" {
  description = "Frequency of subscription notifications"
  type        = string
  default     = "IMMEDIATE"
}

variable "threshold_amount" {
  description = "Threshold amount for anomaly alerts"
  type        = number
  default     = 200
}

variable "monitor_specification" {
  description = "JSON specification for CUSTOM monitor type"
  type        = string
  default     = null
}

variable "subscribers" {
  description = "List of subscribers for anomaly notifications"
  type = list(object({
    type    = string
    address = string
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "production"
    Module      = "cost-anomaly-detection"
  }
}