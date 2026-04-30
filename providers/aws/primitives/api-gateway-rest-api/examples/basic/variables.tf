variable "name" {
  type        = string
  description = "(Required) Name for the REST API."
}

variable "stage_name" {
  type        = string
  description = "(Required) Name of the deployment stage."
}

variable "access_log_group_name" {
  type        = string
  description = "(Required) Name of the CloudWatch log group for API access logs."
}

variable "description" {
  type        = string
  description = "(Optional) Description of the REST API."
  default     = ""
}

variable "endpoint_type" {
  type        = string
  description = "(Optional) Endpoint type. Valid values: EDGE, REGIONAL, PRIVATE."
  default     = "REGIONAL"
}

variable "minimum_compression_size" {
  type        = number
  description = "(Optional) Minimum response size to compress. -1 disables compression."
  default     = -1
}

variable "xray_tracing_enabled" {
  type        = bool
  description = "(Optional) Whether X-Ray tracing is enabled."
  default     = true
}

variable "metrics_enabled" {
  type        = bool
  description = "(Optional) Whether detailed CloudWatch metrics are enabled."
  default     = false
}

variable "logging_level" {
  type        = string
  description = "(Optional) Logging level. Valid values: OFF, ERROR, INFO."
  default     = "INFO"
}

variable "throttling_burst_limit" {
  type        = number
  description = "(Optional) Throttling burst limit."
  default     = -1
}

variable "throttling_rate_limit" {
  type        = number
  description = "(Optional) Throttling rate limit."
  default     = -1
}

variable "log_retention_in_days" {
  type        = number
  description = "(Optional) Number of days to retain API access logs in CloudWatch."
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Tags to apply to resources."
  default     = {}
}
