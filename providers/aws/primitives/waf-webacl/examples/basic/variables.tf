variable "webacl_name" {
  description = "Base Web ACL name (a random suffix is appended)."
  type        = string
}

variable "scope" {
  description = "WAF scope (REGIONAL or CLOUDFRONT)."
  type        = string
  default     = "REGIONAL"
}

variable "default_action" {
  description = "Default action for unmatched requests."
  type        = string
  default     = "allow"
}

variable "rate_limit_per_ip" {
  description = "Per-IP rate limit (5-min sliding window)."
  type        = number
  default     = 2000
}

variable "rate_limit_per_header" {
  description = "Per-header rate limit (5-min sliding window)."
  type        = number
  default     = 1000
}

variable "rate_limit_header_name" {
  description = "Header name to aggregate the per-header rate-limit on."
  type        = string
  default     = "x-caylent-tool"
}

variable "log_retention_in_days" {
  description = "WAF log group retention."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
