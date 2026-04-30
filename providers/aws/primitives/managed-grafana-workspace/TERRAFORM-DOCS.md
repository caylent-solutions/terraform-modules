## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_grafana_role_association.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association) | resource |
| [aws_grafana_role_association.viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association) | resource |
| [aws_grafana_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace) | resource |
| [aws_grafana_workspace_saml_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_saml_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_access_type"></a> [account\_access\_type](#input\_account\_access\_type) | Type of account access for the workspace. CURRENT\_ACCOUNT or ORGANIZATION. | `string` | `"CURRENT_ACCOUNT"` | no |
| <a name="input_admin_role_name"></a> [admin\_role\_name](#input\_admin\_role\_name) | The Grafana role name for admin access (ADMIN, EDITOR, or VIEWER). | `string` | `"ADMIN"` | no |
| <a name="input_admin_sso_group_ids"></a> [admin\_sso\_group\_ids](#input\_admin\_sso\_group\_ids) | List of IAM Identity Center (SSO) group IDs with admin access to the workspace. | `list(string)` | `[]` | no |
| <a name="input_auth_providers"></a> [auth\_providers](#input\_auth\_providers) | List of authentication providers for the workspace. Supported: AWS\_SSO, SAML. | `list(string)` | <pre>[<br/>  "AWS_SSO"<br/>]</pre> | no |
| <a name="input_data_sources"></a> [data\_sources](#input\_data\_sources) | List of data sources the workspace is authorized to retrieve data from. | `list(string)` | <pre>[<br/>  "AMAZON_OPENSEARCH_SERVICE",<br/>  "CLOUDWATCH",<br/>  "XRAY"<br/>]</pre> | no |
| <a name="input_notification_destinations"></a> [notification\_destinations](#input\_notification\_destinations) | List of notification destinations for the workspace. Supported: SNS. | `list(string)` | `[]` | no |
| <a name="input_permission_type"></a> [permission\_type](#input\_permission\_type) | Permission type for the workspace. SERVICE\_MANAGED or CUSTOMER\_MANAGED. | `string` | `"SERVICE_MANAGED"` | no |
| <a name="input_saml_auth_provider_name"></a> [saml\_auth\_provider\_name](#input\_saml\_auth\_provider\_name) | The authentication provider name used to identify SAML in auth\_providers. | `string` | `"SAML"` | no |
| <a name="input_saml_editor_role_values"></a> [saml\_editor\_role\_values](#input\_saml\_editor\_role\_values) | List of SAML assertion attribute values that map to the Grafana Editor role. | `list(string)` | <pre>[<br/>  "editor"<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the Grafana workspace. | `map(string)` | `{}` | no |
| <a name="input_viewer_role_name"></a> [viewer\_role\_name](#input\_viewer\_role\_name) | The Grafana role name for viewer access (ADMIN, EDITOR, or VIEWER). | `string` | `"VIEWER"` | no |
| <a name="input_viewer_sso_group_ids"></a> [viewer\_sso\_group\_ids](#input\_viewer\_sso\_group\_ids) | List of IAM Identity Center (SSO) group IDs with viewer access to the workspace. | `list(string)` | `[]` | no |
| <a name="input_vpc_configuration"></a> [vpc\_configuration](#input\_vpc\_configuration) | VPC configuration for the workspace. Set to null to disable VPC connectivity. | <pre>object({<br/>    security_group_ids = list(string)<br/>    subnet_ids         = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | Name of the Amazon Managed Grafana workspace | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_arn"></a> [workspace\_arn](#output\_workspace\_arn) | The ARN of the Grafana workspace. |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | The ID of the Grafana workspace. |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | The endpoint URL of the Grafana workspace. |
