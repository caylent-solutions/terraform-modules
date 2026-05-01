# Basic Example Documentation

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_workspace"></a> [workspace](#module\_workspace) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_access_type"></a> [account\_access\_type](#input\_account\_access\_type) | How the workspace accesses AWS data sources. | `string` | `"CURRENT_ACCOUNT"` | no |
| <a name="input_authentication_providers"></a> [authentication\_providers](#input\_authentication\_providers) | Identity providers used for workspace login. SAML default avoids the AWS Identity Center prerequisite at workspace creation time. | `list(string)` | <pre>[<br/>  "SAML"<br/>]</pre> | no |
| <a name="input_data_sources"></a> [data\_sources](#input\_data\_sources) | AWS data sources the workspace integrates with. | `list(string)` | <pre>[<br/>  "CLOUDWATCH"<br/>]</pre> | no |
| <a name="input_notification_destinations"></a> [notification\_destinations](#input\_notification\_destinations) | Notification destination types the workspace can publish to. | `list(string)` | <pre>[<br/>  "SNS"<br/>]</pre> | no |
| <a name="input_permission_type"></a> [permission\_type](#input\_permission\_type) | Workspace permission type. | `string` | `"SERVICE_MANAGED"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to module-managed resources. | `map(string)` | <pre>{<br/>  "Example": "basic",<br/>  "ManagedBy": "terraform",<br/>  "Module": "managed-grafana-workspace"<br/>}</pre> | no |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | Base name for the Managed Grafana workspace; the example appends a random suffix. | `string` | `"test-grafana"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_arn"></a> [workspace\_arn](#output\_workspace\_arn) | ARN of the workspace. |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | Identifier of the workspace. |
| <a name="output_workspace_name"></a> [workspace\_name](#output\_workspace\_name) | Configured name of the workspace (with random suffix). |
| <a name="output_workspace_role_arn"></a> [workspace\_role\_arn](#output\_workspace\_role\_arn) | ARN of the IAM role assumed by the workspace. |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | Endpoint URL of the workspace. |
