<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_grafana_workspace"></a> [grafana\_workspace](#module\_grafana\_workspace) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_access_type"></a> [account\_access\_type](#input\_account\_access\_type) | Type of account access for the workspace | `string` | `"CURRENT_ACCOUNT"` | no |
| <a name="input_admin_sso_group_ids"></a> [admin\_sso\_group\_ids](#input\_admin\_sso\_group\_ids) | List of SSO group IDs with admin access | `list(string)` | `[]` | no |
| <a name="input_auth_providers"></a> [auth\_providers](#input\_auth\_providers) | List of authentication providers for the workspace | `list(string)` | <pre>[<br/>  "AWS_SSO"<br/>]</pre> | no |
| <a name="input_data_sources"></a> [data\_sources](#input\_data\_sources) | List of data sources the workspace is authorized to query | `list(string)` | <pre>[<br/>  "AMAZON_OPENSEARCH_SERVICE",<br/>  "CLOUDWATCH",<br/>  "XRAY"<br/>]</pre> | no |
| <a name="input_notification_destinations"></a> [notification\_destinations](#input\_notification\_destinations) | List of notification destinations | `list(string)` | `[]` | no |
| <a name="input_permission_type"></a> [permission\_type](#input\_permission\_type) | Permission type for the workspace | `string` | `"SERVICE_MANAGED"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the Grafana workspace | `map(string)` | `{}` | no |
| <a name="input_viewer_sso_group_ids"></a> [viewer\_sso\_group\_ids](#input\_viewer\_sso\_group\_ids) | List of SSO group IDs with viewer access | `list(string)` | `[]` | no |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | Name of the Amazon Managed Grafana workspace | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_arn"></a> [workspace\_arn](#output\_workspace\_arn) | The ARN of the Grafana workspace |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | The ID of the Grafana workspace |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | The endpoint URL of the Grafana workspace |
<!-- END_TF_DOCS -->