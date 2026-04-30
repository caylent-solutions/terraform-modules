variable "name" {
  type        = string
  description = "Friendly name of the WebACL"
}

variable "description" {
  type        = string
  description = "Friendly description of the WebACL"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

variable "enable_rate_based_rule" {
  type        = bool
  description = "Whether to enable the per-IP rate-based rule"
  default     = true
}

variable "rate_based_rule_limit" {
  type        = number
  description = "Per-IP request limit per 5-minute window"
  default     = 2000
}

variable "rate_based_rule_priority" {
  type        = number
  description = "Priority of the per-IP rate-based rule"
  default     = 10
}

variable "enable_tool_header_rate_rule" {
  type        = bool
  description = "Whether to enable the X-Caylent-Tool header rate-based rule"
  default     = true
}

variable "tool_header_rate_rule_limit" {
  type        = number
  description = "Tool-header rate limit per 5-minute window"
  default     = 1000
}

variable "tool_header_rate_rule_priority" {
  type        = number
  description = "Priority of the X-Caylent-Tool header rate-based rule"
  default     = 20
}

variable "tool_header_name" {
  type        = string
  description = "HTTP header name used as the custom aggregate key"
  default     = "x-caylent-tool"
}

variable "enable_ip_set_rule" {
  type        = bool
  description = "Whether to enable the IP set block rule"
  default     = true
}

variable "ip_set_rule_name" {
  type        = string
  description = "Name for the IP set block rule"
  default     = "block-ip-set"
}

variable "ip_set_rule_priority" {
  type        = number
  description = "Priority of the IP set block rule"
  default     = 30
}

variable "ip_set_addresses" {
  type        = list(string)
  description = "List of IPv4 CIDR ranges to block"
  default     = []
}

variable "enable_core_rule_set" {
  type        = bool
  description = "Whether to enable the AWSManagedRulesCommonRuleSet"
  default     = true
}

variable "enable_known_bad_inputs_rule_set" {
  type        = bool
  description = "Whether to enable the AWSManagedRulesKnownBadInputsRuleSet"
  default     = true
}

variable "enable_ip_reputation_rule_set" {
  type        = bool
  description = "Whether to enable the AWSManagedRulesAmazonIpReputationList"
  default     = true
}

variable "cloudwatch_metrics_enabled" {
  type        = bool
  description = "Whether to enable CloudWatch metrics for the WebACL"
  default     = true
}

variable "sampled_requests_enabled" {
  type        = bool
  description = "Whether to enable sampled request storage"
  default     = true
}
