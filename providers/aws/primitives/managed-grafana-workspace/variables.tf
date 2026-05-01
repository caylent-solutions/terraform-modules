variable "workspace_name" {
  description = "Name of the Managed Grafana workspace."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]{1,255}$", var.workspace_name))
    error_message = "workspace_name must be 1-255 characters from the AWS-allowed set (alphanumerics, dots, underscores, hyphens)."
  }
}

variable "description" {
  description = "Description of the workspace."
  type        = string
  default     = null
}

variable "account_access_type" {
  description = "How the workspace accesses AWS data sources. CURRENT_ACCOUNT (default) or ORGANIZATION."
  type        = string
  default     = "CURRENT_ACCOUNT"

  validation {
    condition     = contains(["CURRENT_ACCOUNT", "ORGANIZATION"], var.account_access_type)
    error_message = "account_access_type must be CURRENT_ACCOUNT or ORGANIZATION."
  }
}

variable "authentication_providers" {
  description = "Identity providers used for workspace login. Default `[\"AWS_SSO\"]` per Q4."
  type        = list(string)
  default     = ["AWS_SSO"]

  validation {
    condition     = length(var.authentication_providers) >= 1 && alltrue([for p in var.authentication_providers : contains(["AWS_SSO", "SAML"], p)])
    error_message = "authentication_providers must be a non-empty list whose entries are AWS_SSO or SAML."
  }
}

variable "permission_type" {
  description = "Workspace permission type. SERVICE_MANAGED (default) lets AWS manage IAM permissions for data sources; CUSTOMER_MANAGED hands that responsibility to the role attached at role_arn."
  type        = string
  default     = "SERVICE_MANAGED"

  validation {
    condition     = contains(["SERVICE_MANAGED", "CUSTOMER_MANAGED"], var.permission_type)
    error_message = "permission_type must be SERVICE_MANAGED or CUSTOMER_MANAGED."
  }
}

variable "data_sources" {
  description = "List of AWS data sources the workspace integrates with. Defaults cover the telemetry stack: AMAZON_OPENSEARCH_SERVICE, CLOUDWATCH, XRAY."
  type        = list(string)
  default     = ["AMAZON_OPENSEARCH_SERVICE", "CLOUDWATCH", "XRAY"]
}

variable "notification_destinations" {
  description = "List of notification destination types the workspace can publish to (e.g. SNS)."
  type        = list(string)
  default     = ["SNS"]
}

variable "create_workspace_role" {
  description = "Whether the module provisions an IAM role for the workspace (assumed by `grafana.amazonaws.com`). Set false to bring your own role and pass `workspace_role_arn`."
  type        = bool
  default     = true
}

variable "workspace_role_arn" {
  description = "ARN of an externally provisioned IAM role for the workspace. Required when create_workspace_role = false."
  type        = string
  default     = null

  validation {
    condition     = var.create_workspace_role || var.workspace_role_arn != null
    error_message = "workspace_role_arn is required when create_workspace_role = false."
  }
}

variable "admin_sso_group_ids" {
  description = "AWS SSO group ids granted ADMIN role on the workspace."
  type        = list(string)
  default     = []
}

variable "editor_sso_group_ids" {
  description = "AWS SSO group ids granted EDITOR role on the workspace."
  type        = list(string)
  default     = []
}

variable "viewer_sso_group_ids" {
  description = "AWS SSO group ids granted VIEWER role on the workspace."
  type        = list(string)
  default     = []
}

variable "vpc_configuration" {
  description = "Optional VPC configuration for the workspace: `{ subnet_ids = list(string), security_group_ids = list(string) }`. Null disables VPC mode."
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "tags" {
  description = "Tags applied to the workspace and (when created) the workspace IAM role."
  type        = map(string)
  default     = {}
}
