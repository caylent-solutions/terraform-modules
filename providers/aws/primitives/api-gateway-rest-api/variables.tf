variable "name" {
  description = "Name of the REST API."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,128}$", var.name))
    error_message = "API name must be 1-128 characters and contain only alphanumerics, hyphens, and underscores."
  }
}

variable "description" {
  description = "Description of the REST API."
  type        = string
  default     = null
}

variable "openapi_body" {
  description = "Optional OpenAPI 3.0 body that defines the API. When null, the API is created without inline definitions and consumers add resources/methods/integrations separately."
  type        = string
  default     = null
}

variable "endpoint_type" {
  description = "API Gateway endpoint type. This primitive supports REGIONAL only (per the spec brief and to keep the custom-domain certificate semantics consistent: REGIONAL uses `regional_certificate_arn` with a regional ACM cert, EDGE requires `certificate_arn` with a us-east-1 cert, PRIVATE has no public custom-domain story). EDGE/PRIVATE consumers should use a dedicated primitive."
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = var.endpoint_type == "REGIONAL"
    error_message = "endpoint_type must be REGIONAL. EDGE and PRIVATE are not supported by this primitive."
  }
}

variable "minimum_compression_size" {
  description = "Minimum response size to enable compression, in bytes. -1 disables compression."
  type        = number
  default     = -1

  validation {
    condition     = var.minimum_compression_size == -1 || (var.minimum_compression_size >= 0 && var.minimum_compression_size <= 10485760)
    error_message = "minimum_compression_size must be -1 (disabled) or between 0 and 10485760 inclusive."
  }
}

variable "binary_media_types" {
  description = "List of MIME types that should be treated as binary by API Gateway."
  type        = list(string)
  default     = []
}

variable "api_key_source" {
  description = "Source of the API key for metering requests. HEADER (X-API-Key) or AUTHORIZER."
  type        = string
  default     = "HEADER"

  validation {
    condition     = contains(["HEADER", "AUTHORIZER"], var.api_key_source)
    error_message = "api_key_source must be HEADER or AUTHORIZER."
  }
}

variable "disable_execute_api_endpoint" {
  description = "Disable the default `*.execute-api.<region>.amazonaws.com` endpoint and force callers through the custom domain."
  type        = bool
  default     = false
}

variable "stage_name" {
  description = "Name of the deployment stage (e.g., prod, dev, v1)."
  type        = string
  default     = "v1"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,128}$", var.stage_name))
    error_message = "Stage name must be 1-128 characters and contain only alphanumerics, hyphens, and underscores."
  }
}

variable "stage_description" {
  description = "Description of the deployment stage."
  type        = string
  default     = null
}

variable "stage_variables" {
  description = "Map of stage-variable name to value. Available to integrations as $${stageVariables.NAME}."
  type        = map(string)
  default     = {}
}

variable "cache_cluster_enabled" {
  description = "Enable an API Gateway response cache for the stage. Defaults to `true` so the module ships with caching on per AWS best practice (and tfsec `aws-api-gateway-enable-cache`). Disabling avoids the per-stage cache cluster fee (smallest 0.5GB cluster bills hourly), so consumers that do not need caching should set this to `false` explicitly."
  type        = bool
  default     = true
}

variable "cache_cluster_size" {
  description = "Cache size in GB. Valid: 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118, 237. Default 0.5 is the smallest billable size."
  type        = string
  default     = "0.5"

  validation {
    condition     = contains(["0.5", "1.6", "6.1", "13.5", "28.4", "58.2", "118", "237"], var.cache_cluster_size)
    error_message = "cache_cluster_size must be one of 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118, 237."
  }
}

variable "xray_tracing_enabled" {
  description = "Enable AWS X-Ray tracing on the stage. Defaults to `true` so the module ships secure-by-default; consumers can override to `false`."
  type        = bool
  default     = true
}

variable "method_metrics_enabled" {
  description = "Enable detailed CloudWatch metrics for all methods on the stage."
  type        = bool
  default     = true
}

variable "method_logging_level" {
  description = "API Gateway logging level for all methods. OFF, ERROR, or INFO."
  type        = string
  default     = "ERROR"

  validation {
    condition     = contains(["OFF", "ERROR", "INFO"], var.method_logging_level)
    error_message = "method_logging_level must be one of OFF, ERROR, or INFO."
  }
}

variable "method_data_trace_enabled" {
  description = "Enable full request/response logging at INFO level. Useful for debugging; not recommended for production."
  type        = bool
  default     = false
}

variable "method_throttling_burst_limit" {
  description = "Default burst limit (requests/sec spike capacity) for all methods on the stage."
  type        = number
  default     = 5000

  validation {
    condition     = var.method_throttling_burst_limit >= 0
    error_message = "method_throttling_burst_limit must be >= 0."
  }
}

variable "method_throttling_rate_limit" {
  description = "Default sustained rate limit (requests/sec) for all methods on the stage."
  type        = number
  default     = 10000

  validation {
    condition     = var.method_throttling_rate_limit >= 0
    error_message = "method_throttling_rate_limit must be >= 0."
  }
}

variable "create_access_log_group" {
  description = "Create a CloudWatch Log Group for stage access logs (used when access_log_destination_arn is not provided). Defaults to `true` so the module ships secure-by-default with stage access logging enabled; consumers can override to `false` and supply `access_log_destination_arn` instead."
  type        = bool
  default     = true
}

variable "access_log_destination_arn" {
  description = "ARN of an existing CloudWatch Log Group, Kinesis Firehose, or Kinesis stream to receive access logs. When null and create_access_log_group = true, the module creates a Log Group."
  type        = string
  default     = null
}

variable "access_log_retention_in_days" {
  description = "Retention for the auto-created access log group (only used when create_access_log_group = true)."
  type        = number
  default     = 30

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.access_log_retention_in_days)
    error_message = "access_log_retention_in_days must be one of the values supported by CloudWatch Logs (1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653)."
  }
}

variable "access_log_kms_key_arn" {
  description = "KMS key ARN to encrypt the auto-created access log group. Null uses AWS-managed encryption."
  type        = string
  default     = null
}

variable "access_log_format" {
  description = "Access log format. Default is the standard JSON format containing requestId, sourceIp, requestTime, httpMethod, resourcePath, status, protocol, and responseLength."
  type        = string
  default     = "{\"requestId\":\"$context.requestId\",\"sourceIp\":\"$context.identity.sourceIp\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\",\"status\":\"$context.status\",\"protocol\":\"$context.protocol\",\"responseLength\":\"$context.responseLength\"}"
}

variable "custom_domain_name" {
  description = "Custom domain name to attach to the API. When null, no custom domain or base-path mapping is created."
  type        = string
  default     = null
}

variable "custom_domain_certificate_arn" {
  description = "ACM certificate ARN for the REGIONAL custom domain. Required when custom_domain_name is set. The certificate must be in the SAME region as the API (REGIONAL custom domains do not use a us-east-1 cert; that requirement applies to EDGE-optimized custom domains, which this primitive does not support)."
  type        = string
  default     = null

  validation {
    condition     = var.custom_domain_certificate_arn != null || var.custom_domain_name == null
    error_message = "custom_domain_certificate_arn is required when custom_domain_name is set."
  }
}

variable "custom_domain_security_policy" {
  description = "Minimum TLS version for the custom domain. TLS_1_2 (recommended) or TLS_1_0."
  type        = string
  default     = "TLS_1_2"

  validation {
    condition     = contains(["TLS_1_0", "TLS_1_2"], var.custom_domain_security_policy)
    error_message = "custom_domain_security_policy must be TLS_1_0 or TLS_1_2."
  }
}

variable "custom_domain_base_path" {
  description = "Base path for the custom-domain mapping. Empty string maps to the root of the custom domain."
  type        = string
  default     = ""
}

variable "create_usage_plan" {
  description = "Create an API Gateway usage plan that targets this stage."
  type        = bool
  default     = false
}

variable "usage_plan_description" {
  description = "Description for the usage plan."
  type        = string
  default     = null
}

variable "usage_plan_throttle" {
  description = "Throttle settings for the usage plan: { burst_limit, rate_limit }. Null disables plan-level throttling."
  type = object({
    burst_limit = number
    rate_limit  = number
  })
  default = null
}

variable "usage_plan_quota" {
  description = "Quota settings for the usage plan: { limit, offset (optional), period (DAY|WEEK|MONTH) }. Null disables plan-level quotas."
  type = object({
    limit  = number
    offset = optional(number)
    period = string
  })
  default = null

  validation {
    condition     = var.usage_plan_quota == null || contains(["DAY", "WEEK", "MONTH"], coalesce(try(var.usage_plan_quota.period, ""), ""))
    error_message = "usage_plan_quota.period must be one of DAY, WEEK, or MONTH."
  }
}

variable "tags" {
  description = "Tags applied to the REST API and stage (and to derived resources where supported)."
  type        = map(string)
  default     = {}
}
