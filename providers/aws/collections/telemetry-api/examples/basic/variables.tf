variable "web_acl_name" {
  description = "Base name for the WAF Web ACL fronting the API; the example appends a random suffix."
  type        = string
  default     = "test-telemetry-waf"
}

variable "authorizer_function_name" {
  description = "Base name for the HMAC-SHA256 authorizer Lambda; the example appends a random suffix."
  type        = string
  default     = "test-telemetry-authz"
}

variable "api_name" {
  description = "Base name for the REST API; the example appends a random suffix."
  type        = string
  default     = "test-telemetry-api"
}

variable "api_stage_name" {
  description = "Deployment stage name."
  type        = string
  default     = "prod"
}

variable "tags" {
  description = "Tags applied to module-managed resources."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Module    = "telemetry-api"
    Example   = "basic"
  }
}
