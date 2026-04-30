variable "workspace_name" {
  description = "Name of the Amazon Managed Grafana workspace"
  type        = string
}

variable "account_access_type" {
  description = "Type of account access for the workspace"
  type        = string
  default     = "CURRENT_ACCOUNT"
}

variable "auth_providers" {
  description = "List of authentication providers for the workspace"
  type        = list(string)
  default     = ["AWS_SSO"]
}

variable "permission_type" {
  description = "Permission type for the workspace"
  type        = string
  default     = "SERVICE_MANAGED"
}

variable "data_sources" {
  description = "List of data sources the workspace is authorized to query"
  type        = list(string)
  default     = ["AMAZON_OPENSEARCH_SERVICE", "CLOUDWATCH", "XRAY"]
}

variable "notification_destinations" {
  description = "List of notification destinations"
  type        = list(string)
  default     = []
}

variable "admin_sso_group_ids" {
  description = "List of SSO group IDs with admin access"
  type        = list(string)
  default     = []
}

variable "viewer_sso_group_ids" {
  description = "List of SSO group IDs with viewer access"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the Grafana workspace"
  type        = map(string)
  default     = {}
}
