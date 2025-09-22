## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_identitystore_group.sso_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group) | resource |
| [aws_identitystore_group_membership.sso_group_membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership) | resource |
| [aws_identitystore_group_membership.sso_group_membership_existing_google_sso_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership) | resource |
| [aws_identitystore_group_membership.sso_group_membership_existing_sso_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership) | resource |
| [aws_identitystore_user.sso_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_user) | resource |
| [aws_ssoadmin_account_assignment.account_assignment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_customer_managed_policy_attachment.pset_customer_managed_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_customer_managed_policy_attachment) | resource |
| [aws_ssoadmin_managed_policy_attachment.pset_aws_managed_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.pset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.pset_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [aws_ssoadmin_permissions_boundary_attachment.pset_permissions_boundary_aws_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permissions_boundary_attachment) | resource |
| [aws_ssoadmin_permissions_boundary_attachment.pset_permissions_boundary_customer_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permissions_boundary_attachment) | resource |
| [aws_identitystore_group.existing_sso_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) | data source |
| [aws_identitystore_user.existing_google_sso_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_user) | data source |
| [aws_identitystore_user.existing_sso_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_user) | data source |
| [aws_organizations_organization.organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_ssoadmin_instances.sso_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |
| [aws_ssoadmin_permission_set.existing_permission_sets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_permission_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_assignments"></a> [account\_assignments](#input\_account\_assignments) | List of maps containing mapping between user/group, permission set and assigned accounts list. See account\_assignments description in README for more information about map values. | <pre>map(object({<br/>    principal_name  = string<br/>    principal_type  = string<br/>    principal_idp   = string # acceptable values are either "INTERNAL" or "EXTERNAL"<br/>    permission_sets = list(string)<br/>    account_ids     = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_existing_google_sso_users"></a> [existing\_google\_sso\_users](#input\_existing\_google\_sso\_users) | Names of the existing Google users that you wish to reference from IAM Identity Center. | <pre>map(object({<br/>    user_name        = string<br/>    group_membership = optional(list(string), null) // only used if your IdP only syncs users, and you wish to manage which groups they should go in<br/>  }))</pre> | `{}` | no |
| <a name="input_existing_permission_sets"></a> [existing\_permission\_sets](#input\_existing\_permission\_sets) | Names of the existing permission\_sets that you wish to reference from IAM Identity Center. | <pre>map(object({<br/>    permission_set_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_existing_sso_groups"></a> [existing\_sso\_groups](#input\_existing\_sso\_groups) | Names of the existing groups that you wish to reference from IAM Identity Center. | <pre>map(object({<br/>    group_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_existing_sso_users"></a> [existing\_sso\_users](#input\_existing\_sso\_users) | Names of the existing users that you wish to reference from IAM Identity Center. | <pre>map(object({<br/>    user_name        = string<br/>    group_membership = optional(list(string), null) // only used if your IdP only syncs users, and you wish to manage which groups they should go in<br/>  }))</pre> | `{}` | no |
| <a name="input_permission_sets"></a> [permission\_sets](#input\_permission\_sets) | Permission Sets that you wish to create in IAM Identity Center. This variable is a map of maps containing Permission Set names as keys. See permission\_sets description in README for information about map values. | `any` | `{}` | no |
| <a name="input_sso_groups"></a> [sso\_groups](#input\_sso\_groups) | Names of the groups you wish to create in IAM Identity Center. | <pre>map(object({<br/>    group_name        = string<br/>    group_description = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_sso_users"></a> [sso\_users](#input\_sso\_users) | Names of the users you wish to create in IAM Identity Center. | <pre>map(object({<br/>    display_name     = optional(string)<br/>    user_name        = string<br/>    group_membership = list(string)<br/>    # Name<br/>    given_name       = string<br/>    middle_name      = optional(string, null)<br/>    family_name      = string<br/>    name_formatted   = optional(string)<br/>    honorific_prefix = optional(string, null)<br/>    honorific_suffix = optional(string, null)<br/>    # Email<br/>    email            = string<br/>    email_type       = optional(string, null)<br/>    is_primary_email = optional(bool, true)<br/>    # Phone Number<br/>    phone_number            = optional(string, null)<br/>    phone_number_type       = optional(string, null)<br/>    is_primary_phone_number = optional(bool, true)<br/>    # Address<br/>    country            = optional(string, " ")<br/>    locality           = optional(string, " ")<br/>    address_formatted  = optional(string)<br/>    postal_code        = optional(string, " ")<br/>    is_primary_address = optional(bool, true)<br/>    region             = optional(string, " ")<br/>    street_address     = optional(string, " ")<br/>    address_type       = optional(string, null)<br/>    # Additional<br/>    user_type          = optional(string, null)<br/>    title              = optional(string, null)<br/>    locale             = optional(string, null)<br/>    nickname           = optional(string, null)<br/>    preferred_language = optional(string, null)<br/>    profile_url        = optional(string, null)<br/>    timezone           = optional(string, null)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_assignment_data"></a> [account\_assignment\_data](#output\_account\_assignment\_data) | Tuple containing account assignment data |
| <a name="output_principals_and_assignments"></a> [principals\_and\_assignments](#output\_principals\_and\_assignments) | Map containing account assignment data |
| <a name="output_sso_groups_ids"></a> [sso\_groups\_ids](#output\_sso\_groups\_ids) | A map of SSO groups ids created by this module |
