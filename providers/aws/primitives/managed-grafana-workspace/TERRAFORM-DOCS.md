## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_grafana_role_association.admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association) | resource |
| [aws_grafana_role_association.editor](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association) | resource |
| [aws_grafana_role_association.viewer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association) | resource |
| [aws_grafana_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace) | resource |
| [aws_iam_role.workspace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_access_type"></a> [account\_access\_type](#input\_account\_access\_type) | How the workspace accesses AWS data sources. CURRENT\_ACCOUNT (default) or ORGANIZATION. | `string` | `"CURRENT_ACCOUNT"` | no |
| <a name="input_admin_sso_group_ids"></a> [admin\_sso\_group\_ids](#input\_admin\_sso\_group\_ids) | AWS SSO group ids granted ADMIN role on the workspace. | `list(string)` | `[]` | no |
| <a name="input_authentication_providers"></a> [authentication\_providers](#input\_authentication\_providers) | Identity providers used for workspace login. Default `["AWS_SSO"]` per Q4. | `list(string)` | <pre>[<br/>  "AWS_SSO"<br/>]</pre> | no |
| <a name="input_create_workspace_role"></a> [create\_workspace\_role](#input\_create\_workspace\_role) | Whether the module provisions an IAM role for the workspace (assumed by `grafana.amazonaws.com`). Set false to bring your own role and pass `workspace_role_arn`. | `bool` | `true` | no |
| <a name="input_data_sources"></a> [data\_sources](#input\_data\_sources) | List of AWS data sources the workspace integrates with. Defaults cover the telemetry stack: AMAZON\_OPENSEARCH\_SERVICE, CLOUDWATCH, XRAY. | `list(string)` | <pre>[<br/>  "AMAZON_OPENSEARCH_SERVICE",<br/>  "CLOUDWATCH",<br/>  "XRAY"<br/>]</pre> | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the workspace. | `string` | `null` | no |
| <a name="input_editor_sso_group_ids"></a> [editor\_sso\_group\_ids](#input\_editor\_sso\_group\_ids) | AWS SSO group ids granted EDITOR role on the workspace. | `list(string)` | `[]` | no |
| <a name="input_notification_destinations"></a> [notification\_destinations](#input\_notification\_destinations) | List of notification destination types the workspace can publish to (e.g. SNS). | `list(string)` | <pre>[<br/>  "SNS"<br/>]</pre> | no |
| <a name="input_permission_type"></a> [permission\_type](#input\_permission\_type) | Workspace permission type. SERVICE\_MANAGED (default) lets AWS manage IAM permissions for data sources; CUSTOMER\_MANAGED hands that responsibility to the role attached at role\_arn. | `string` | `"SERVICE_MANAGED"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the workspace and (when created) the workspace IAM role. | `map(string)` | `{}` | no |
| <a name="input_viewer_sso_group_ids"></a> [viewer\_sso\_group\_ids](#input\_viewer\_sso\_group\_ids) | AWS SSO group ids granted VIEWER role on the workspace. | `list(string)` | `[]` | no |
| <a name="input_vpc_configuration"></a> [vpc\_configuration](#input\_vpc\_configuration) | Optional VPC configuration for the workspace: `{ subnet_ids = list(string), security_group_ids = list(string) }`. Null disables VPC mode. | <pre>object({<br/>    subnet_ids         = list(string)<br/>    security_group_ids = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | Name of the Managed Grafana workspace. | `string` | n/a | yes |
| <a name="input_workspace_role_arn"></a> [workspace\_role\_arn](#input\_workspace\_role\_arn) | ARN of an externally provisioned IAM role for the workspace. Required when create\_workspace\_role = false. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_arn"></a> [workspace\_arn](#output\_workspace\_arn) | ARN of the Managed Grafana workspace. |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | Identifier of the Managed Grafana workspace. |
| <a name="output_workspace_role_arn"></a> [workspace\_role\_arn](#output\_workspace\_role\_arn) | ARN of the IAM role assumed by the workspace (module-managed when create\_workspace\_role = true; otherwise the value passed via workspace\_role\_arn). |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | Endpoint URL of the Managed Grafana workspace. |
