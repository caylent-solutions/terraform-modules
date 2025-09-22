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
