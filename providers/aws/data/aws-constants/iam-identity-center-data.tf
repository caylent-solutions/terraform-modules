# IAM Identity Center API Constants
# These constants can be validated against AWS SSO Admin API

locals {
  # Principal types from AWS SSO Admin API
  iam_identity_center_principal_types = {
    group = "GROUP"
    user  = "USER"
  }

  # Identity provider types from AWS SSO Admin API
  iam_identity_center_identity_provider_types = {
    internal = "INTERNAL"
    external = "EXTERNAL"
    google   = "GOOGLE"
  }

  # Permission set configuration keys from AWS SSO Admin API
  iam_identity_center_permission_set_keys = {
    description      = "description"
    relay_state      = "relay_state"
    session_duration = "session_duration"
    tags             = "tags"
  }

  # Policy attachment property names from AWS SSO Admin API
  iam_identity_center_policy_properties = {
    aws_managed_policies              = "aws_managed_policies"
    customer_managed_policies         = "customer_managed_policies"
    inline_policy                     = "inline_policy"
    managed_policy_arn                = "managed_policy_arn"
    customer_managed_policy_reference = "customer_managed_policy_reference"
    permissions_boundary              = "permissions_boundary"
    pset_name                         = "pset_name"
    policy_arn                        = "policy_arn"
    policy_name                       = "policy_name"
    boundary                          = "boundary"
  }
}