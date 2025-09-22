# AWS Control Tower Controls Module

> [!WARNING]
>
> ❌ Examples provided should NOT be considered a RECOMMENDATION or BEST PRACTICE for how Control Tower Controls should be structured or applied within your AWS ORGANIZATION.
>
> ⚡ Each ORGANIZATION should:
> 1. Carefully evaluate their SECURITY REQUIREMENTS
> 2. Chose Controls that align with their specific GOVERNANCE needs
> 3. Evaluate their COMPLIANCE REQUIREMENTS
> 4. Ensure Controls will not cause unintentional disruption to existent workloads
> 5. Ensure Change Management processes are being followed
>
> Make sure before applying this module that your organization has processes in place to handle the above.

---

This module lets you apply [Control Tower Controls](https://docs.aws.amazon.com/controltower/latest/controlreference/introduction.html) to OUs.

## Usage

```hcl
locals {
  # Map of OUs to be used for target so users
  # don't have to remember or look up the OU IDs
  ou_map = {
    "production_ou"   = "ou-qyyj-cuxntp0t" # test_ou1
    "sandbox_ou"   = "ou-qyyj-ads8zuff" # test_ou2
  }
}

module "controls" {
  source = "../../"

  map_ous_controls = {

    "sandbox_controls" = {
      ou_ids                       = [local.ou_map["sandbox_ou"]]
      strongly_recommended_controls = true
      elective_controls             = true
      data_residency_controls       = true
      individual_controls = [
        "8uk3vrotlr08jfb0cbxp5klbs"
      ]
    }

    "production_controls" = {
      ou_ids                       = [local.ou_map["production_ou"]]
      strongly_recommended_controls = true
      individual_controls = [
        "8uk3vrotlr08jfb0cbxp5klbs",
        "AWS-GR_SUBNET_AUTO_ASSIGN_PUBLIC_IP_DISABLED"
      ]
    }
  }
}
```

You can choose to apply any of the `strongly_recommended_controls`, `elective_controls`, or `data_residency_controls`, as well as individual controls listed in [controlsList.tf](controlsList.tf) and documented in [The AWS Control Tower Controls Library](https://docs.aws.amazon.com/controltower/latest/controlreference/controls-reference.html).


To specify an arbitrary control by its API controlIdentifier (ARN), use the `individual_controls` property. The `individual_controls` can contain NAME or ID, as in the following example. You can also mix IDs and Names within the same block.

```
individual_controls = [
  "6rilu41n0gb9w6mxrkyewoer4",                      # Name: AWS-GR_RESTRICTED_SSH
  "AWS-GR_SUBNET_AUTO_ASSIGN_PUBLIC_IP_DISABLED"    # ID: 50z1ot237wl8u1lv5ufau6qqo
]
```

> [!TIP]
>
> ⚡ You can use the `parallelism` flag to control the number of resources that are created in parallel. The default is 10, and if you're dealing with a lot of controls the execution can take a while. Example:
>
> `terraform apply -parallelism=30`
>
> Controls API currently supports up to 100 operations in parallel.

## Nested OU Levels

The [data.tf](data.tf) file contains mappings for OU IDs up to the 3rd level. See the commented Level 4 resource if you need that depth.

Example of OU depth:

```
Level 0:  Root (OU)
Level 1:  ├── Security
Level 1:  ├── AFT-Management
Level 1:  └── Production
Level 2:      ├── Prod-NVirginia
Level 2:      └── Prod-Ohio
Level 3:          └── Ohio-Infra
```

See the [examples/complete](examples/complete) directory for more information.

## Permissions

These are the minimum permissions required to apply this module:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "controltower:EnableControl",
                "controltower:DisableControl",
                "controltower:GetControlOperation",
                "controltower:ListEnabledControls",
                "organizations:AttachPolicy",
                "organizations:CreatePolicy",
                "organizations:DeletePolicy",
                "organizations:DescribeOrganization",
                "organizations:DetachPolicy",
                "organizations:ListAccounts",
                "organizations:ListAWSServiceAccessForOrganization",
                "organizations:ListChildren",
                "organizations:ListOrganizationalUnitsForParent",
                "organizations:ListParents",
                "organizations:ListPoliciesForTarget",
                "organizations:ListRoots",
                "organizations:UpdatePolicy"
            ],
            "Resource": "*"
        }
    ]
}
```

---

This module is loosely based on [aws-samples/aws-control-tower-controls-terraform](https://github.com/aws-samples/aws-control-tower-controls-terraform).

<!-- BEGIN_TF_DOCS -->
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
| [aws_controltower_control.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/controltower_control) | resource |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_organizations_organizational_units.level_2_children](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level_3_children](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.level_4_children](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_organizations_organizational_units.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organizational_units) | data source |
| [aws_region.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_map_ous_controls"></a> [map\_ous\_controls](#input\_map\_ous\_controls) | Mapping of OU groups to specific control configurations and OU targets | <pre>map(object({<br/><br/>    ou_ids = list(string)<br/><br/>    strongly_recommended_controls = optional(bool, false)<br/>    elective_controls             = optional(bool, false)<br/>    data_residency_controls       = optional(bool, false)<br/><br/>    # Controls identified by their NAME or CONTROL_CATALOG_OPAQUE_ID<br/>    # Example = "AWS-GR_CT_AUDIT_BUCKET_POLICY_CHANGES_PROHIBITED" or "dmvclaluiuvtsmivvw5t7an1x"<br/>    individual_controls = optional(list(string), [])<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_control_reference"></a> [control\_reference](#output\_control\_reference) | List of all available AWS Control Tower controls with descriptions. |
