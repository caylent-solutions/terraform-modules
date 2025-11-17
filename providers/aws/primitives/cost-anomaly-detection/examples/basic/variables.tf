variable "name" {
  description = "Name of the cost anomaly detector"
  type        = string
  default     = "test-cost-anomaly-detector"
}

variable "monitor_type" {
  description = "Type of monitor"
  type        = string
  default     = "DIMENSIONAL"
}



variable "subscription_frequency" {
  description = "Frequency of subscription notifications"
  type        = string
  default     = "DAILY"
}

variable "threshold_amount" {
  description = "Threshold amount for anomaly alerts"
  type        = number
  default     = 100
}

variable "subscribers" {
  description = "List of subscribers for anomaly notifications"
  type = list(object({
    type    = string
    address = string
  }))
  default = []
}

variable "monitor_specification" {
  description = "JSON specification for CUSTOM monitor type"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "test"
    Module      = "cost-anomaly-detection"
  }
}