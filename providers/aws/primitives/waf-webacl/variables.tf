variable "name" {
  description = "Name of the Web ACL. Used as the CloudWatch metric base name and as the prefix for derived rule names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,128}$", var.name))
    error_message = "Web ACL name must be 1-128 characters and contain only alphanumerics, hyphens, and underscores."
  }
}

variable "description" {
  description = "Description of the Web ACL."
  type        = string
  default     = null
}

variable "scope" {
  description = "Scope of the Web ACL. REGIONAL (for ALB / API Gateway / AppSync / App Runner / Cognito user pool) or CLOUDFRONT (must be created in us-east-1)."
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "scope must be REGIONAL or CLOUDFRONT."
  }
}

variable "default_action" {
  description = "Default action for requests that match no rules. `allow` (most common; rules are explicit blocks) or `block` (deny-by-default)."
  type        = string
  default     = "allow"

  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "default_action must be allow or block."
  }
}

variable "cloudwatch_metrics_enabled" {
  description = "Enable CloudWatch metrics for the Web ACL and each rule."
  type        = bool
  default     = true
}

variable "sampled_requests_enabled" {
  description = "Enable sampled-requests collection in the WAF console."
  type        = bool
  default     = true
}

variable "managed_rule_groups" {
  description = "AWS Managed Rule Groups to attach. Each entry: { name, priority, override (optional, `none` to enforce or `count` to monitor only) }."
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

  validation {
    condition     = alltrue([for g in var.managed_rule_groups : contains(["none", "count"], coalesce(g.override, "none"))])
    error_message = "managed_rule_groups[].override must be 'none' (enforce) or 'count' (monitor)."
  }
}

variable "rate_limit_per_ip" {
  description = "Per-IP rate-based rule: `{ priority, limit }` (5-min sliding window). Null disables this rule."
  type = object({
    priority = number
    limit    = number
  })
  default = null

  validation {
    condition     = var.rate_limit_per_ip == null || (try(var.rate_limit_per_ip.limit, 0) >= 100 && try(var.rate_limit_per_ip.limit, 0) <= 20000000)
    error_message = "rate_limit_per_ip.limit must be 100-20,000,000 (AWS WAF rate-based rule range)."
  }
}

variable "rate_limit_per_header" {
  description = "Per-header rate-based rule (custom aggregate key): `{ priority, limit, header_name }` (5-min sliding window, lowercased). Null disables this rule."
  type = object({
    priority    = number
    limit       = number
    header_name = string
  })
  default = null

  validation {
    condition     = var.rate_limit_per_header == null || (try(var.rate_limit_per_header.limit, 0) >= 100 && try(var.rate_limit_per_header.limit, 0) <= 20000000)
    error_message = "rate_limit_per_header.limit must be 100-20,000,000 (AWS WAF rate-based rule range)."
  }
}

variable "logging_enabled" {
  description = "Enable WAF logging via `aws_wafv2_web_acl_logging_configuration`. Requires either log_destination_arn OR create_log_group."
  type        = bool
  default     = true

  validation {
    condition     = !(var.logging_enabled) || var.log_destination_arn != null || var.create_log_group
    error_message = "logging_enabled = true requires either log_destination_arn or create_log_group = true."
  }
}

variable "create_log_group" {
  description = "Create a CloudWatch Log Group for WAF logs. The group name must start with `aws-waf-logs-` per AWS WAF requirements; the module enforces that prefix."
  type        = bool
  default     = true
}

variable "log_destination_arn" {
  description = "ARN of an existing CloudWatch Log Group (must start with `aws-waf-logs-`), Kinesis Firehose, or S3 bucket to receive WAF logs. Null + create_log_group=true uses the auto-created log group."
  type        = string
  default     = null
}

variable "log_retention_in_days" {
  description = "Retention for the auto-created log group (only used when create_log_group = true)."
  type        = number
  default     = 30

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_in_days)
    error_message = "log_retention_in_days must be one of the values supported by CloudWatch Logs."
  }
}

variable "log_kms_key_arn" {
  description = "KMS key ARN to encrypt the auto-created log group. Null uses AWS-managed encryption."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the Web ACL and (when created) the log group."
  type        = map(string)
  default     = {}
}
