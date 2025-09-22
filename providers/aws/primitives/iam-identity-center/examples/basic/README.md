# Basic Example

This directory contains a basic example of how to use the IAM Identity Center Terraform module.

## Important

The example provided uses tfvars to comply with the test features required in this repository. However, a better strategy would be to use `locals` to define `account_ids` and `account_assignments`. This way you would only need to handle one reference to an account id and you'd be able to set the same local in the different account assignments for the different permission sets, avoiding the repetition of hardcoded values. Check out the Usage block below for a clear example:     
## Usage

```hcl
locals {
  # Account IDs
  networking_account = "111111111111"
  management_account = "222222222222"
  # account3_account_id = "333333333333"
  # account4_account_id = "444444444444"
}

locals {
  sso_groups = {
    Admin : {
      group_name        = "Admin"
      group_description = "Admin Group"
    },
    Billing : {
      group_name        = "Billing"
      group_description = "Billing Group"
    },
  }

  existing_sso_users = {
    "jeronimo.orlando" : {
      user_name        = "jeronimo.orlando@caylent.com"
      group_membership = ["Admin"]
    }
    "nicolas.diaz" : {
      user_name        = "nicolas.diaz@caylent.com"
      group_membership = ["Billing"]
    }
  }

  account_assignments = {
    Admin : {
      principal_name = "Admin"
      principal_type = "GROUP"
      principal_idp  = "INTERNAL"
      permission_sets = [
        "AdministratorAccess",
        "Billing"
      ]
      account_ids = [local.management_account, local.networking_account]
    },
    Billing : {
      principal_name = "Billing"
      principal_type = "GROUP"
      principal_idp  = "INTERNAL"
      permission_sets = [
        "Billing",
      ]
      account_ids = [local.management_account]
    }
  }

  permission_sets = {
    AdministratorAccess = {
      description   = "AdministratorAccess"
      tags          = { ManagedBy = "Terraform" }
      inline_policy = data.aws_iam_policy_document.EC2Access.json,
      aws_managed_policies = [
        "arn:aws:iam::aws:policy/IAMFullAccess",
        "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess",
        "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
      ]
      customer_managed_policies = []
      permission_boundary       = []
    },
    Billing = {
      description   = "Billing"
      tags          = { ManagedBy = "Terraform" }
      inline_policy = data.aws_iam_policy_document.S3Access.json
      aws_managed_policies = [
        "arn:aws:iam::aws:policy/PowerUserAccess",
        "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
      ]
      customer_managed_policies = []
      permission_boundary       = []
    }
  }
}

module "aws-iam-identity-center" {
  source = "../.."

  sso_groups          = local.sso_groups
  permission_sets     = local.permission_sets
  account_assignments = local.account_assignments
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_identity_center"></a> [iam\_identity\_center](#module\_iam\_identity\_center) | ../.. | n/a |

## Resources

No resources.

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
