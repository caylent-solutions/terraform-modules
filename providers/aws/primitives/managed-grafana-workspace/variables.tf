variable "workspace_name" {
  description = "Name of the Amazon Managed Grafana workspace"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.workspace_name))
    error_message = "Workspace name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "account_access_type" {
  description = "Type of account access for the workspace. CURRENT_ACCOUNT or ORGANIZATION."
  type        = string
  default     = "CURRENT_ACCOUNT"

  validation {
    condition     = contains(["CURRENT_ACCOUNT", "ORGANIZATION"], var.account_access_type)
    error_message = "account_access_type must be either CURRENT_ACCOUNT or ORGANIZATION."
  }
}

variable "auth_providers" {
  description = "List of authentication providers for the workspace. Supported: AWS_SSO, SAML."
  type        = list(string)
  default     = ["AWS_SSO"]

  validation {
    condition     = length(var.auth_providers) > 0 && alltrue([for p in var.auth_providers : contains(["AWS_SSO", "SAML"], p)])
    error_message = "auth_providers must be a non-empty list containing only AWS_SSO and/or SAML."
  }
}

variable "data_sources" {
  description = "List of data sources the workspace is authorized to retrieve data from."
  type        = list(string)
  default     = ["AMAZON_OPENSEARCH_SERVICE", "CLOUDWATCH", "XRAY"]

  validation {
    condition = alltrue([
      for ds in var.data_sources :
      contains(["AMAZON_OPENSEARCH_SERVICE", "CLOUDWATCH", "PROMETHEUS", "XRAY", "TIMESTREAM", "SITEWISE", "REDSHIFT", "ATHENA"], ds)
    ])
    error_message = "Each data_source must be one of: AMAZON_OPENSEARCH_SERVICE, CLOUDWATCH, PROMETHEUS, XRAY, TIMESTREAM, SITEWISE, REDSHIFT, ATHENA."
  }
}

variable "notification_destinations" {
  description = "List of notification destinations for the workspace. Supported: SNS."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for nd in var.notification_destinations : contains(["SNS"], nd)])
    error_message = "Each notification_destination must be SNS."
  }
}

variable "permission_type" {
  description = "Permission type for the workspace. SERVICE_MANAGED or CUSTOMER_MANAGED."
  type        = string
  default     = "SERVICE_MANAGED"

  validation {
    condition     = contains(["SERVICE_MANAGED", "CUSTOMER_MANAGED"], var.permission_type)
    error_message = "permission_type must be either SERVICE_MANAGED or CUSTOMER_MANAGED."
  }
}

variable "admin_sso_group_ids" {
  description = "List of IAM Identity Center (SSO) group IDs with admin access to the workspace."
  type        = list(string)
  default     = []
}

variable "viewer_sso_group_ids" {
  description = "List of IAM Identity Center (SSO) group IDs with viewer access to the workspace."
  type        = list(string)
  default     = []
}

variable "vpc_configuration" {
  description = "VPC configuration for the workspace. Set to null to disable VPC connectivity."
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}

variable "saml_auth_provider_name" {
  description = "The authentication provider name used to identify SAML in auth_providers."
  type        = string
  default     = "SAML"
}

variable "saml_editor_role_values" {
  description = "List of SAML assertion attribute values that map to the Grafana Editor role."
  type        = list(string)
  default     = ["editor"]
}

variable "admin_role_name" {
  description = "The Grafana role name for admin access (ADMIN, EDITOR, or VIEWER)."
  type        = string
  default     = "ADMIN"

  validation {
    condition     = contains(["ADMIN", "EDITOR", "VIEWER"], var.admin_role_name)
    error_message = "admin_role_name must be one of: ADMIN, EDITOR, VIEWER."
  }
}

variable "viewer_role_name" {
  description = "The Grafana role name for viewer access (ADMIN, EDITOR, or VIEWER)."
  type        = string
  default     = "VIEWER"

  validation {
    condition     = contains(["ADMIN", "EDITOR", "VIEWER"], var.viewer_role_name)
    error_message = "viewer_role_name must be one of: ADMIN, EDITOR, VIEWER."
  }
}

variable "tags" {
  description = "Tags to apply to the Grafana workspace."
  type        = map(string)
  default     = {}
}
