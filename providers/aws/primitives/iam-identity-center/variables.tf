# Groups
variable "sso_groups" {
  description = "Names of the groups you wish to create in IAM Identity Center."
  type = map(object({
    group_name        = string
    group_description = optional(string, null)
  }))
  default = {}
}
variable "existing_sso_groups" {
  description = "Names of the existing groups that you wish to reference from IAM Identity Center."
  type = map(object({
    group_name = string
  }))
  default = {}
}

# Users
variable "sso_users" {
  description = "Names of the users you wish to create in IAM Identity Center."
  type = map(object({
    display_name     = optional(string)
    user_name        = string
    group_membership = list(string)
    # Name
    given_name       = string
    middle_name      = optional(string, null)
    family_name      = string
    name_formatted   = optional(string)
    honorific_prefix = optional(string, null)
    honorific_suffix = optional(string, null)
    # Email
    email            = string
    email_type       = optional(string, null)
    is_primary_email = optional(bool, true)
    # Phone Number
    phone_number            = optional(string, null)
    phone_number_type       = optional(string, null)
    is_primary_phone_number = optional(bool, true)
    # Address
    country            = optional(string, null)
    locality           = optional(string, null)
    address_formatted  = optional(string)
    postal_code        = optional(string, null)
    is_primary_address = optional(bool, true)
    region             = optional(string, null)
    street_address     = optional(string, null)
    address_type       = optional(string, null)
    # Additional
    user_type          = optional(string, null)
    title              = optional(string, null)
    locale             = optional(string, null)
    nickname           = optional(string, null)
    preferred_language = optional(string, null)
    profile_url        = optional(string, null)
    timezone           = optional(string, null)
  }))
  default = {}

  validation {
    condition     = alltrue([for user in values(var.sso_users) : length(user.user_name) > 1 && length(user.user_name) <= 128])
    error_message = "The name of one of the defined IAM Identity Store (SSO) Users is too long. User_names can be a maxmium of 128 characters. Please ensure all user_names are 100 characters or less, and try again."
  }
}
variable "existing_sso_users" {
  description = "Names of the existing users that you wish to reference from IAM Identity Center."
  type = map(object({
    user_name        = string
    group_membership = optional(list(string), null) // only used if your IdP only syncs users, and you wish to manage which groups they should go in
  }))
  default = {}
}
variable "existing_google_sso_users" {
  description = "Names of the existing Google users that you wish to reference from IAM Identity Center."
  type = map(object({
    user_name        = string
    group_membership = optional(list(string), null) // only used if your IdP only syncs users, and you wish to manage which groups they should go in
  }))
  default = {}
}


# Permission Sets
variable "permission_sets" {
  description = "Permission Sets that you wish to create in IAM Identity Center. This variable is a map of maps containing Permission Set names as keys. See permission_sets description in README for information about map values."
  type        = any
  default     = {}
}
variable "existing_permission_sets" {
  description = "Names of the existing permission_sets that you wish to reference from IAM Identity Center."
  type = map(object({
    permission_set_name = string
  }))
  default = {}
}

#  Account Assignments
variable "account_assignments" {
  description = "List of maps containing mapping between user/group, permission set and assigned accounts list. See account_assignments description in README for more information about map values."
  type = map(object({
    principal_name  = string
    principal_type  = string
    principal_idp   = string # acceptable values are either "INTERNAL" or "EXTERNAL"
    permission_sets = list(string)
    account_ids     = list(string)
  }))

  default = {}
}

# Configuration variables to replace hard-coded values
variable "identity_store_display_name_attribute" {
  description = "The attribute path for display name in identity store"
  type        = string
  default     = "DisplayName"
}

variable "identity_store_username_attribute" {
  description = "The attribute path for username in identity store"
  type        = string
  default     = "UserName"
}

variable "customer_managed_policy_path" {
  description = "The path for customer managed policies"
  type        = string
  default     = "/"
}

variable "target_type" {
  description = "The target type for account assignments"
  type        = string
  default     = "AWS_ACCOUNT"
}

variable "address_field_separator" {
  description = "The separator used to join address fields"
  type        = string
  default     = " "
}

variable "name_field_separator" {
  description = "The separator used to join name fields"
  type        = string
  default     = " "
}

variable "empty_string_default" {
  description = "Default empty string value for address fields"
  type        = string
  default     = ""
}

variable "account_status_filter" {
  description = "The account status to filter for in organization accounts"
  type        = string
  default     = "ACTIVE"
}
