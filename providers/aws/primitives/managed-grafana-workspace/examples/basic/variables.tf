variable "workspace_name" {
  description = "Base name for the Managed Grafana workspace; the example appends a random suffix."
  type        = string
  default     = "test-grafana"
}

variable "authentication_providers" {
  description = "Identity providers used for workspace login. SAML default avoids the AWS Identity Center prerequisite at workspace creation time."
  type        = list(string)
  default     = ["SAML"]
}

variable "account_access_type" {
  description = "How the workspace accesses AWS data sources."
  type        = string
  default     = "CURRENT_ACCOUNT"
}

variable "permission_type" {
  description = "Workspace permission type."
  type        = string
  default     = "SERVICE_MANAGED"
}

variable "data_sources" {
  description = "AWS data sources the workspace integrates with."
  type        = list(string)
  default     = ["CLOUDWATCH"]
}

variable "notification_destinations" {
  description = "Notification destination types the workspace can publish to."
  type        = list(string)
  default     = ["SNS"]
}

variable "tags" {
  description = "Tags applied to module-managed resources."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Module    = "managed-grafana-workspace"
    Example   = "basic"
  }
}
