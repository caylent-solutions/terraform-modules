variable "name" {
  type        = string
  description = "(Required) Friendly name of the WebACL."
  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "name must be between 1 and 128 characters."
  }
}

variable "description" {
  type        = string
  description = "(Optional) Friendly description of the WebACL."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Map of tags to assign to the WebACL and associated resources."
  default     = {}
}

variable "managed_by_tag" {
  type        = string
  description = "(Optional) Value for the ManagedBy tag applied to all resources."
  default     = "terraform"
}

variable "module_tag" {
  type        = string
  description = "(Optional) Value for the Module tag applied to all resources."
  default     = "waf-webacl"
}

# Rate-based rule (per-IP)

variable "enable_rate_based_rule" {
  type        = bool
  description = "(Optional) Whether to enable the default per-IP rate-based rule."
  default     = true
}

variable "rate_based_rule_name" {
  type        = string
  description = "(Optional) Name for the per-IP rate-based rule."
  default     = "rate-limit-per-ip"
}

variable "rate_based_rule_priority" {
  type        = number
  description = "(Optional) Priority of the per-IP rate-based rule. Lower numbers are evaluated first."
  default     = 10
  validation {
    condition     = var.rate_based_rule_priority >= 0 && var.rate_based_rule_priority <= 99999
    error_message = "rate_based_rule_priority must be between 0 and 99999."
  }
}

variable "rate_based_rule_limit" {
  type        = number
  description = "(Optional) Aggregate request limit per 5-minute window for the per-IP rate-based rule."
  default     = 2000
  validation {
    condition     = var.rate_based_rule_limit >= 100 && var.rate_based_rule_limit <= 2000000000
    error_message = "rate_based_rule_limit must be between 100 and 2,000,000,000."
  }
}

# Rate-based rule with custom aggregate key (X-Caylent-Tool header)

variable "enable_tool_header_rate_rule" {
  type        = bool
  description = "(Optional) Whether to enable the rate-based rule that aggregates on the X-Caylent-Tool HTTP header."
  default     = true
}

variable "tool_header_rate_rule_name" {
  type        = string
  description = "(Optional) Name for the X-Caylent-Tool header rate-based rule."
  default     = "rate-limit-per-tool-header"
}

variable "tool_header_rate_rule_priority" {
  type        = number
  description = "(Optional) Priority of the X-Caylent-Tool header rate-based rule."
  default     = 20
  validation {
    condition     = var.tool_header_rate_rule_priority >= 0 && var.tool_header_rate_rule_priority <= 99999
    error_message = "tool_header_rate_rule_priority must be between 0 and 99999."
  }
}

variable "tool_header_rate_rule_limit" {
  type        = number
  description = "(Optional) Aggregate request limit per 5-minute window for the X-Caylent-Tool header rate-based rule."
  default     = 1000
  validation {
    condition     = var.tool_header_rate_rule_limit >= 100 && var.tool_header_rate_rule_limit <= 2000000000
    error_message = "tool_header_rate_rule_limit must be between 100 and 2,000,000,000."
  }
}

variable "tool_header_name" {
  type        = string
  description = "(Optional) The HTTP header name used as the custom aggregate key for the tool-header rate rule."
  default     = "x-caylent-tool"
}

# IP set block rule

variable "enable_ip_set_rule" {
  type        = bool
  description = "(Optional) Whether to enable the IP set block rule."
  default     = false
}

variable "ip_set_rule_name" {
  type        = string
  description = "(Optional) Name for the IP set block rule."
  default     = "block-ip-set"
}

variable "ip_set_rule_priority" {
  type        = number
  description = "(Optional) Priority of the IP set block rule."
  default     = 30
  validation {
    condition     = var.ip_set_rule_priority >= 0 && var.ip_set_rule_priority <= 99999
    error_message = "ip_set_rule_priority must be between 0 and 99999."
  }
}

variable "ip_set_addresses" {
  type        = list(string)
  description = "(Optional) List of CIDR ranges to block. IPv4 (e.g. 192.0.2.0/24) ranges are accepted."
  default     = []
}

# AWS managed rule groups

variable "enable_core_rule_set" {
  type        = bool
  description = "(Optional) Whether to enable the AWSManagedRulesCommonRuleSet managed rule group."
  default     = true
}

variable "core_rule_set_priority" {
  type        = number
  description = "(Optional) Priority of the AWSManagedRulesCommonRuleSet rule group."
  default     = 40
  validation {
    condition     = var.core_rule_set_priority >= 0 && var.core_rule_set_priority <= 99999
    error_message = "core_rule_set_priority must be between 0 and 99999."
  }
}

variable "enable_known_bad_inputs_rule_set" {
  type        = bool
  description = "(Optional) Whether to enable the AWSManagedRulesKnownBadInputsRuleSet managed rule group."
  default     = true
}

variable "known_bad_inputs_rule_set_priority" {
  type        = number
  description = "(Optional) Priority of the AWSManagedRulesKnownBadInputsRuleSet rule group."
  default     = 50
  validation {
    condition     = var.known_bad_inputs_rule_set_priority >= 0 && var.known_bad_inputs_rule_set_priority <= 99999
    error_message = "known_bad_inputs_rule_set_priority must be between 0 and 99999."
  }
}

variable "enable_ip_reputation_rule_set" {
  type        = bool
  description = "(Optional) Whether to enable the AWSManagedRulesAmazonIpReputationList managed rule group."
  default     = true
}

variable "ip_reputation_rule_set_priority" {
  type        = number
  description = "(Optional) Priority of the AWSManagedRulesAmazonIpReputationList rule group."
  default     = 60
  validation {
    condition     = var.ip_reputation_rule_set_priority >= 0 && var.ip_reputation_rule_set_priority <= 99999
    error_message = "ip_reputation_rule_set_priority must be between 0 and 99999."
  }
}

# CloudWatch metrics

variable "cloudwatch_metrics_enabled" {
  type        = bool
  description = "(Optional) Whether to enable CloudWatch metrics for the WebACL."
  default     = true
}

variable "sampled_requests_enabled" {
  type        = bool
  description = "(Optional) Whether AWS WAF should store a sampling of the web requests that match the rules."
  default     = true
}

# Logging

variable "enable_logging" {
  type        = bool
  description = "(Optional) Whether to enable WAF logging to a Kinesis Firehose or S3 destination."
  default     = false
}

variable "logging_destination_arns" {
  type        = list(string)
  description = "(Optional) List of ARNs of the logging destinations (Kinesis Firehose or S3). Required when enable_logging is true."
  default     = []
  validation {
    condition     = !(var.enable_logging && length(var.logging_destination_arns) == 0)
    error_message = "logging_destination_arns must not be empty when enable_logging is true."
  }
}

# Resource association

variable "resource_arns" {
  type        = list(string)
  description = "(Optional) List of ARNs of resources to associate with the WebACL (ALB, API Gateway REST API, AppSync GraphQL API, Cognito User Pool, App Runner Service, Verified Access Instance)."
  default     = []
}

# AWS API constants -- underscore-prefixed per OPA hardcoded_values_policy

variable "_wafv2_scope_regional" {
  type        = string
  description = "AWS WAFv2 scope value for regional resources. Must be REGIONAL."
  default     = "REGIONAL"
  validation {
    condition     = var._wafv2_scope_regional == "REGIONAL"
    error_message = "_wafv2_scope_regional must be REGIONAL."
  }
}

variable "_wafv2_vendor_name" {
  type        = string
  description = "AWS vendor name for managed rule groups. Must be AWS."
  default     = "AWS"
  validation {
    condition     = var._wafv2_vendor_name == "AWS"
    error_message = "_wafv2_vendor_name must be AWS."
  }
}

variable "_wafv2_core_rule_group_name" {
  type        = string
  description = "AWS managed rule group name for core rules. Must be AWSManagedRulesCommonRuleSet."
  default     = "AWSManagedRulesCommonRuleSet"
  validation {
    condition     = var._wafv2_core_rule_group_name == "AWSManagedRulesCommonRuleSet"
    error_message = "_wafv2_core_rule_group_name must be AWSManagedRulesCommonRuleSet."
  }
}

variable "_wafv2_known_bad_inputs_rule_group_name" {
  type        = string
  description = "AWS managed rule group name for known bad inputs. Must be AWSManagedRulesKnownBadInputsRuleSet."
  default     = "AWSManagedRulesKnownBadInputsRuleSet"
  validation {
    condition     = var._wafv2_known_bad_inputs_rule_group_name == "AWSManagedRulesKnownBadInputsRuleSet"
    error_message = "_wafv2_known_bad_inputs_rule_group_name must be AWSManagedRulesKnownBadInputsRuleSet."
  }
}

variable "_wafv2_ip_reputation_rule_group_name" {
  type        = string
  description = "AWS managed rule group name for IP reputation. Must be AWSManagedRulesAmazonIpReputationList."
  default     = "AWSManagedRulesAmazonIpReputationList"
  validation {
    condition     = var._wafv2_ip_reputation_rule_group_name == "AWSManagedRulesAmazonIpReputationList"
    error_message = "_wafv2_ip_reputation_rule_group_name must be AWSManagedRulesAmazonIpReputationList."
  }
}

variable "_wafv2_ip_version_ipv4" {
  type        = string
  description = "AWS WAFv2 IP version for IPv4 sets. Must be IPV4."
  default     = "IPV4"
  validation {
    condition     = var._wafv2_ip_version_ipv4 == "IPV4"
    error_message = "_wafv2_ip_version_ipv4 must be IPV4."
  }
}

variable "_wafv2_rate_limit_aggregation_key_type_ip" {
  type        = string
  description = "AWS WAFv2 aggregate key type for IP-based rate limiting. Must be IP."
  default     = "IP"
  validation {
    condition     = var._wafv2_rate_limit_aggregation_key_type_ip == "IP"
    error_message = "_wafv2_rate_limit_aggregation_key_type_ip must be IP."
  }
}

variable "_wafv2_rate_limit_aggregation_key_type_custom" {
  type        = string
  description = "AWS WAFv2 aggregate key type for custom header rate limiting. Must be CUSTOM_KEYS."
  default     = "CUSTOM_KEYS"
  validation {
    condition     = var._wafv2_rate_limit_aggregation_key_type_custom == "CUSTOM_KEYS"
    error_message = "_wafv2_rate_limit_aggregation_key_type_custom must be CUSTOM_KEYS."
  }
}

variable "_wafv2_header_oversize_handling" {
  type        = string
  description = "AWS WAFv2 oversize handling for custom header keys. Must be one of: CONTINUE, MATCH, NO_MATCH."
  default     = "CONTINUE"
  validation {
    condition     = contains(["CONTINUE", "MATCH", "NO_MATCH"], var._wafv2_header_oversize_handling)
    error_message = "_wafv2_header_oversize_handling must be one of: CONTINUE, MATCH, NO_MATCH."
  }
}

