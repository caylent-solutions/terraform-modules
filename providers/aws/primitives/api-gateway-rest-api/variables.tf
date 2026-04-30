# Required variables

variable "name" {
  type        = string
  description = "(Required) Name for the REST API and associated resources."

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "name must be between 1 and 128 characters."
  }
}

variable "stage_name" {
  type        = string
  description = "(Required) Name of the stage to deploy the REST API to."

  validation {
    condition     = length(var.stage_name) > 0 && length(var.stage_name) <= 128
    error_message = "stage_name must be between 1 and 128 characters."
  }
}

# API configuration

variable "description" {
  type        = string
  description = "(Optional) Description of the REST API."
  default     = ""
}

variable "binary_media_types" {
  type        = list(string)
  description = "(Optional) List of binary media types supported by the REST API."
  default     = []
}

variable "minimum_compression_size" {
  type        = number
  description = "(Optional) Minimum response size to compress for the REST API. -1 disables compression. Value between -1 and 10485760 (10 MB)."
  default     = -1

  validation {
    condition     = var.minimum_compression_size == -1 || (var.minimum_compression_size >= 0 && var.minimum_compression_size <= 10485760)
    error_message = "minimum_compression_size must be -1 (disabled) or between 0 and 10485760."
  }
}

variable "api_key_source" {
  type        = string
  description = "(Optional) Source of the API key for requests. Valid values: HEADER, AUTHORIZER."
  default     = "HEADER"

  validation {
    condition     = contains(["HEADER", "AUTHORIZER"], var.api_key_source)
    error_message = "api_key_source must be one of: HEADER, AUTHORIZER."
  }
}

variable "endpoint_type" {
  type        = string
  description = "(Optional) Endpoint type for the REST API. Valid values: EDGE, REGIONAL, PRIVATE."
  default     = "REGIONAL"

  validation {
    condition     = contains(["EDGE", "REGIONAL", "PRIVATE"], var.endpoint_type)
    error_message = "endpoint_type must be one of: EDGE, REGIONAL, PRIVATE."
  }
}

# Stage configuration

variable "stage_description" {
  type        = string
  description = "(Optional) Description of the stage."
  default     = ""
}

variable "stage_variables" {
  type        = map(string)
  description = "(Optional) Map defining stage variables."
  default     = {}
}

variable "xray_tracing_enabled" {
  type        = bool
  description = "(Optional) Whether active tracing with X-Ray is enabled for the stage."
  default     = true
}

variable "cache_cluster_enabled" {
  type        = bool
  description = "(Optional) Whether a cache cluster is enabled for the stage."
  default     = false
}

variable "cache_enabled" {
  type        = bool
  description = "(Optional) Whether response caching is enabled in method settings. Defaults to true to improve API performance and reduce backend load."
  default     = true
}

variable "cache_data_encrypted" {
  type        = bool
  description = "(Optional) Whether the cached responses are encrypted. Defaults to true for security compliance."
  default     = true
}

variable "cache_cluster_size" {
  type        = string
  description = "(Optional) Size of the cache cluster for the stage, if enabled. Valid values: 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118, 237."
  default     = "0.5"

  validation {
    condition     = contains(["0.5", "1.6", "6.1", "13.5", "28.4", "58.2", "118", "237"], var.cache_cluster_size)
    error_message = "cache_cluster_size must be one of: 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118, 237."
  }
}

# CloudWatch logging

variable "cloudwatch_logs_role_arn" {
  type        = string
  description = "(Optional) ARN of an IAM role for pushing logs from API Gateway to CloudWatch. Required when access_log_destination_arn is set."
  default     = null
}

variable "access_log_destination_arn" {
  type        = string
  description = "(Required) ARN of the CloudWatch log group or Kinesis Data Firehose delivery stream to receive access logs."
}

variable "access_log_format" {
  type        = string
  description = "(Optional) Formatting and values recorded in the access logs. Defaults to a standard JSON format including requestId, ip, caller, user, requestTime, httpMethod, resourcePath, status, protocol, and responseLength."
  default     = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"caller\":\"$context.identity.caller\",\"user\":\"$context.identity.user\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\",\"status\":\"$context.status\",\"protocol\":\"$context.protocol\",\"responseLength\":\"$context.responseLength\"}"
}

variable "logging_level" {
  type        = string
  description = "(Optional) Logging level for execution logs. Valid values: OFF, ERROR, INFO."
  default     = "OFF"

  validation {
    condition     = contains(["OFF", "ERROR", "INFO"], var.logging_level)
    error_message = "logging_level must be one of: OFF, ERROR, INFO."
  }
}

variable "data_trace_enabled" {
  type        = bool
  description = "(Optional) Whether data trace logging is enabled for the default route. Has no effect when logging_level is OFF."
  default     = false
}

variable "metrics_enabled" {
  type        = bool
  description = "(Optional) Whether detailed metrics are enabled for the default route."
  default     = false
}

variable "throttling_burst_limit" {
  type        = number
  description = "(Optional) Throttling burst limit for the stage default method settings."
  default     = -1
}

variable "throttling_rate_limit" {
  type        = number
  description = "(Optional) Throttling rate limit for the stage default method settings."
  default     = -1
}

# Custom domain support

variable "domain_name" {
  type        = string
  description = "(Optional) Custom domain name for the REST API. When set, a domain name mapping and base path mapping are created."
  default     = null
}

variable "domain_certificate_arn" {
  type        = string
  description = "(Optional) ARN of an ACM certificate to use for the custom domain. Required when domain_name is set."
  default     = null
}

variable "base_path" {
  type        = string
  description = "(Optional) Base path to map to the REST API stage when using a custom domain."
  default     = null
}

variable "domain_security_policy" {
  type        = string
  description = "(Optional) TLS security policy for the custom domain. Only TLS_1_2 is supported."
  default     = "TLS_1_2"

  validation {
    condition     = var.domain_security_policy == "TLS_1_2"
    error_message = "domain_security_policy must be TLS_1_2."
  }
}

# WAF association

variable "web_acl_arn" {
  type        = string
  description = "(Optional) ARN of a WAFv2 Web ACL to associate with the stage."
  default     = null
}

# Usage plan

variable "usage_plan_name" {
  type        = string
  description = "(Optional) Name for an associated usage plan. When set, a usage plan is created and associated with the stage."
  default     = null
}

variable "usage_plan_description" {
  type        = string
  description = "(Optional) Description of the usage plan."
  default     = ""
}

variable "usage_plan_quota_limit" {
  type        = number
  description = "(Optional) Maximum number of requests that can be made in a given time period for the usage plan."
  default     = null
}

variable "usage_plan_quota_offset" {
  type        = number
  description = "(Optional) Number of requests subtracted from the given limit in the initial time period for the usage plan."
  default     = 0
}

variable "usage_plan_quota_period" {
  type        = string
  description = "(Optional) Time period in which the limit applies. Valid values: DAY, WEEK, MONTH."
  default     = null

  validation {
    condition     = var.usage_plan_quota_period == null || contains(["DAY", "WEEK", "MONTH"], var.usage_plan_quota_period)
    error_message = "usage_plan_quota_period must be one of: DAY, WEEK, MONTH."
  }
}

variable "usage_plan_throttle_burst_limit" {
  type        = number
  description = "(Optional) Throttle burst limit for the usage plan."
  default     = null
}

variable "usage_plan_throttle_rate_limit" {
  type        = number
  description = "(Optional) Throttle rate limit for the usage plan."
  default     = null
}

# Tags

variable "tags" {
  type        = map(string)
  description = "(Optional) A map of tags to assign to resources."
  default     = {}
}

variable "managed_by_tag" {
  type        = string
  description = "(Optional) Value for the ManagedBy tag."
  default     = "terraform"
}

variable "module_tag" {
  type        = string
  description = "(Optional) Value for the Module tag."
  default     = "api-gateway-rest-api"
}

# AWS API constant variables -- underscore prefix indicates these are AWS service constants
# used in resource blocks to avoid hardcoded string literals

variable "_method_path_all" {
  type        = string
  description = "AWS API constant: method path wildcard for all methods and resources."
  default     = "*/*"
}
