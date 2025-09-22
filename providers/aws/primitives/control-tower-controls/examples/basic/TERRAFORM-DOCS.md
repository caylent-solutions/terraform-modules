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
| <a name="module_controls"></a> [controls](#module\_controls) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_map_ous_controls"></a> [map\_ous\_controls](#input\_map\_ous\_controls) | Mapping of OU groups to specific control configurations and OU targets | <pre>map(object({<br/><br/>    ou_ids = list(string)<br/><br/>    strongly_recommended_controls = optional(bool, false)<br/>    elective_controls             = optional(bool, false)<br/>    data_residency_controls       = optional(bool, false)<br/><br/>    # Controls identified by their NAME or CONTROL_CATALOG_OPAQUE_ID<br/>    # Example = "AWS-GR_CT_AUDIT_BUCKET_POLICY_CHANGES_PROHIBITED" or "dmvclaluiuvtsmivvw5t7an1x"<br/>    individual_controls = optional(list(string), [])<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
