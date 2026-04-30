variable "api_name" {
  description = "Base API name (a random suffix is appended)."
  type        = string
}

variable "endpoint_type" {
  description = "API Gateway endpoint type."
  type        = string
  default     = "REGIONAL"
}

variable "stage_name" {
  description = "Stage name."
  type        = string
  default     = "v1"
}

variable "xray_tracing_enabled" {
  description = "Enable X-Ray tracing on the stage."
  type        = bool
  default     = false
}

variable "method_metrics_enabled" {
  description = "Enable detailed CloudWatch metrics."
  type        = bool
  default     = true
}

variable "method_logging_level" {
  description = "Method logging level."
  type        = string
  default     = "ERROR"
}

variable "create_access_log_group" {
  description = "Create the auto-managed CloudWatch Log Group for stage access logs."
  type        = bool
  default     = true
}

variable "access_log_retention_in_days" {
  description = "Access log retention in days."
  type        = number
  default     = 7
}

variable "create_usage_plan" {
  description = "Create a usage plan."
  type        = bool
  default     = true
}

variable "create_account_cloudwatch_role" {
  description = "Whether the example provisions the per-account API Gateway CloudWatch Logs role required to enable any stage-level logging. Default true so the example is self-contained."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
