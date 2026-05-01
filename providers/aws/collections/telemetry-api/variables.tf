# --- WAF (waf-webacl primitive) -----------------------------------------------

variable "web_acl_name" {
  description = "Name of the WAF Web ACL fronting the telemetry API."
  type        = string
}

variable "web_acl_description" {
  description = "Description of the Web ACL."
  type        = string
  default     = null
}

variable "web_acl_scope" {
  description = "Scope of the Web ACL. REGIONAL for API Gateway, CLOUDFRONT only when fronting CloudFront (must be us-east-1)."
  type        = string
  default     = "REGIONAL"
}

variable "web_acl_default_action" {
  description = "Default action for unmatched requests. allow or block."
  type        = string
  default     = "allow"
}

variable "web_acl_managed_rule_groups" {
  description = "AWS Managed Rule Groups to attach to the Web ACL."
  type = list(object({
    name     = string
    priority = number
    override = optional(string, "none")
  }))
  default = [
    { name = "AWSManagedRulesCommonRuleSet", priority = 10, override = "none" },
    { name = "AWSManagedRulesKnownBadInputsRuleSet", priority = 20, override = "none" },
    { name = "AWSManagedRulesAmazonIpReputationList", priority = 30, override = "none" },
  ]
}

variable "web_acl_rate_limit_per_ip" {
  description = "Per-IP rate-based rule (5-min sliding window). Null disables this rule."
  type = object({
    priority = number
    limit    = number
  })
  default = {
    priority = 100
    limit    = 2000
  }
}

variable "web_acl_rate_limit_per_header" {
  description = "Per-header rate-based rule (5-min sliding window) keyed by HTTP header name. Null disables this rule."
  type = object({
    priority    = number
    limit       = number
    header_name = string
  })
  default = null
}

variable "web_acl_cloudwatch_metrics_enabled" {
  description = "Whether CloudWatch metrics are enabled for the Web ACL and its rules."
  type        = bool
  default     = true
}

variable "web_acl_sampled_requests_enabled" {
  description = "Whether sampled requests collection is enabled for the Web ACL and its rules."
  type        = bool
  default     = true
}

variable "web_acl_logging_enabled" {
  description = "Whether to enable WAF logging."
  type        = bool
  default     = true
}

variable "web_acl_create_log_group" {
  description = "Whether to create a CloudWatch log group for WAF logs (only when web_acl_logging_enabled = true and no log_destination_arn is supplied)."
  type        = bool
  default     = true
}

variable "web_acl_log_destination_arn" {
  description = "Externally provisioned WAF log destination ARN. When null, an auto-managed CloudWatch log group is used."
  type        = string
  default     = null
}

variable "web_acl_log_retention_in_days" {
  description = "Retention (days) for the auto-managed WAF log group."
  type        = number
  default     = 30
}

variable "web_acl_log_kms_key_arn" {
  description = "KMS CMK ARN used to encrypt the auto-managed WAF log group at rest."
  type        = string
  default     = null
}

# --- Lambda HMAC-SHA256 authorizer (lambda primitive) -------------------------

variable "authorizer_function_name" {
  description = "Name of the HMAC-SHA256 authorizer Lambda function."
  type        = string
}

variable "authorizer_description" {
  description = "Description of the authorizer Lambda function."
  type        = string
  default     = "HMAC-SHA256 authorizer for the telemetry API"
}

variable "authorizer_role_arn" {
  description = "IAM role ARN the authorizer Lambda assumes (must allow lambda.amazonaws.com to AssumeRole and grant CloudWatch Logs writes)."
  type        = string
}

variable "authorizer_package_type" {
  description = "Lambda packaging type. Zip or Image."
  type        = string
  default     = "Zip"
}

variable "authorizer_filename" {
  description = "Path to the local Zip artifact containing the authorizer source. Mutually exclusive with authorizer_s3_bucket/authorizer_s3_key and authorizer_image_uri."
  type        = string
  default     = null
}

variable "authorizer_s3_bucket" {
  description = "S3 bucket holding the authorizer Zip artifact."
  type        = string
  default     = null
}

variable "authorizer_s3_key" {
  description = "S3 key for the authorizer Zip artifact."
  type        = string
  default     = null
}

variable "authorizer_image_uri" {
  description = "ECR image URI for the authorizer (only when package_type = Image)."
  type        = string
  default     = null
}

variable "authorizer_handler" {
  description = "Authorizer handler entrypoint (Zip package only)."
  type        = string
  default     = null
}

variable "authorizer_runtime" {
  description = "Authorizer Lambda runtime (Zip package only)."
  type        = string
  default     = null
}

variable "authorizer_memory_size" {
  description = "Authorizer Lambda memory size in MB."
  type        = number
  default     = 256
}

variable "authorizer_timeout" {
  description = "Authorizer Lambda execution timeout in seconds."
  type        = number
  default     = 5
}

variable "authorizer_environment" {
  description = "Plain (non-secret) environment variables for the authorizer Lambda."
  type        = map(string)
  default     = {}
}

# --- API Gateway REST API (api-gateway-rest-api primitive) --------------------

variable "api_name" {
  description = "Name of the REST API."
  type        = string
}

variable "api_description" {
  description = "Description of the REST API."
  type        = string
  default     = null
}

variable "api_openapi_body" {
  description = "OpenAPI 3.0 body (string) defining the REST API surface and integrations. The api-gateway-rest-api primitive imports this verbatim via body."
  type        = string
}

variable "api_endpoint_type" {
  description = "API Gateway endpoint configuration. Locked to REGIONAL by the primitive."
  type        = string
  default     = "REGIONAL"
}

variable "api_stage_name" {
  description = "Deployment stage name."
  type        = string
  default     = "prod"
}

variable "api_stage_description" {
  description = "Deployment stage description."
  type        = string
  default     = null
}

variable "api_xray_tracing_enabled" {
  description = "Whether X-Ray tracing is enabled on the stage."
  type        = bool
  default     = true
}

variable "api_cache_cluster_enabled" {
  description = "Whether the stage's cache cluster is enabled (required for stage-level caching)."
  type        = bool
  default     = true
}

variable "api_cache_cluster_size" {
  description = "Stage cache cluster size."
  type        = string
  default     = "0.5"
}

variable "api_method_logging_level" {
  description = "Method-level logging level. OFF, ERROR, or INFO."
  type        = string
  default     = "INFO"
}

variable "api_method_metrics_enabled" {
  description = "Whether per-method CloudWatch metrics are enabled."
  type        = bool
  default     = true
}

variable "api_method_throttling_burst_limit" {
  description = "Per-method throttling burst limit."
  type        = number
  default     = 5000
}

variable "api_method_throttling_rate_limit" {
  description = "Per-method throttling steady-state rate limit (requests/second)."
  type        = number
  default     = 10000
}

variable "api_create_access_log_group" {
  description = "Whether the primitive provisions a CloudWatch log group for stage access logs."
  type        = bool
  default     = true
}

variable "api_access_log_destination_arn" {
  description = "Externally provisioned access log destination ARN. When null and create_access_log_group = true, an auto-managed log group is used."
  type        = string
  default     = null
}

variable "api_access_log_retention_in_days" {
  description = "Retention (days) for the auto-managed stage access log group."
  type        = number
  default     = 30
}

variable "api_access_log_kms_key_arn" {
  description = "KMS CMK ARN used to encrypt the auto-managed stage access log group at rest."
  type        = string
  default     = null
}

# --- Custom domain + DNS alias (api-gateway-rest-api + route53-record) -------

variable "custom_domain_name" {
  description = "Custom domain name attached to the REST API. When null, no custom domain or DNS alias record is created."
  type        = string
  default     = null
}

variable "custom_domain_certificate_arn" {
  description = "ACM certificate ARN used by the custom domain. Required when custom_domain_name is set."
  type        = string
  default     = null

  validation {
    condition     = var.custom_domain_name == null || var.custom_domain_certificate_arn != null
    error_message = "custom_domain_certificate_arn is required when custom_domain_name is set."
  }
}

variable "custom_domain_security_policy" {
  description = "TLS security policy for the custom domain (TLS_1_2 recommended)."
  type        = string
  default     = "TLS_1_2"
}

variable "custom_domain_base_path" {
  description = "Optional base path mapping for the custom domain (null means root)."
  type        = string
  default     = null
}

variable "route53_zone_id" {
  description = "Route53 hosted zone id where the alias record is created. Required when custom_domain_name is set."
  type        = string
  default     = null

  validation {
    condition     = var.custom_domain_name == null || var.route53_zone_id != null
    error_message = "route53_zone_id is required when custom_domain_name is set."
  }
}

# --- Common ------------------------------------------------------------------

variable "tags" {
  description = "Tags applied to all module-managed resources."
  type        = map(string)
  default     = {}
}
