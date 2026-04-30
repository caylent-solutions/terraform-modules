# Basic Example Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api"></a> [api](#module\_api) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_iam_role.apigw_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.apigw_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_retention_in_days"></a> [access\_log\_retention\_in\_days](#input\_access\_log\_retention\_in\_days) | Access log retention in days. | `number` | `7` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | Base API name (a random suffix is appended). | `string` | n/a | yes |
| <a name="input_create_access_log_group"></a> [create\_access\_log\_group](#input\_create\_access\_log\_group) | Create the auto-managed CloudWatch Log Group for stage access logs. | `bool` | `true` | no |
| <a name="input_create_account_cloudwatch_role"></a> [create\_account\_cloudwatch\_role](#input\_create\_account\_cloudwatch\_role) | Whether the example provisions the per-account API Gateway CloudWatch Logs role required to enable any stage-level logging. Default true so the example is self-contained. | `bool` | `true` | no |
| <a name="input_create_usage_plan"></a> [create\_usage\_plan](#input\_create\_usage\_plan) | Create a usage plan. | `bool` | `true` | no |
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | API Gateway endpoint type. | `string` | `"REGIONAL"` | no |
| <a name="input_method_logging_level"></a> [method\_logging\_level](#input\_method\_logging\_level) | Method logging level. | `string` | `"ERROR"` | no |
| <a name="input_method_metrics_enabled"></a> [method\_metrics\_enabled](#input\_method\_metrics\_enabled) | Enable detailed CloudWatch metrics. | `bool` | `true` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | Stage name. | `string` | `"v1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_xray_tracing_enabled"></a> [xray\_tracing\_enabled](#input\_xray\_tracing\_enabled) | Enable X-Ray tracing on the stage. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_log_group_arn"></a> [access\_log\_group\_arn](#output\_access\_log\_group\_arn) | Access log group ARN, or null when not created. |
| <a name="output_rest_api_arn"></a> [rest\_api\_arn](#output\_rest\_api\_arn) | ARN of the REST API. |
| <a name="output_rest_api_id"></a> [rest\_api\_id](#output\_rest\_api\_id) | ID of the REST API. |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | Stage ARN. |
| <a name="output_stage_invoke_url"></a> [stage\_invoke\_url](#output\_stage\_invoke\_url) | Stage invoke URL on the default execute-api endpoint. |
| <a name="output_stage_name"></a> [stage\_name](#output\_stage\_name) | Stage name. |
| <a name="output_usage_plan_id"></a> [usage\_plan\_id](#output\_usage\_plan\_id) | Usage plan ID, or null when not created. |
<!-- END_TF_DOCS -->