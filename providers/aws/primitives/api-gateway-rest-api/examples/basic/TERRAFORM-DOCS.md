## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway_rest_api"></a> [api\_gateway\_rest\_api](#module\_api\_gateway\_rest\_api) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.api_access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_group_name"></a> [access\_log\_group\_name](#input\_access\_log\_group\_name) | (Required) Name of the CloudWatch log group for API access logs. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Description of the REST API. | `string` | `""` | no |
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | (Optional) Endpoint type. Valid values: EDGE, REGIONAL, PRIVATE. | `string` | `"REGIONAL"` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | (Optional) Number of days to retain API access logs in CloudWatch. | `number` | `30` | no |
| <a name="input_logging_level"></a> [logging\_level](#input\_logging\_level) | (Optional) Logging level. Valid values: OFF, ERROR, INFO. | `string` | `"INFO"` | no |
| <a name="input_metrics_enabled"></a> [metrics\_enabled](#input\_metrics\_enabled) | (Optional) Whether detailed CloudWatch metrics are enabled. | `bool` | `false` | no |
| <a name="input_minimum_compression_size"></a> [minimum\_compression\_size](#input\_minimum\_compression\_size) | (Optional) Minimum response size to compress. -1 disables compression. | `number` | `-1` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name for the REST API. | `string` | n/a | yes |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | (Required) Name of the deployment stage. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Tags to apply to resources. | `map(string)` | `{}` | no |
| <a name="input_throttling_burst_limit"></a> [throttling\_burst\_limit](#input\_throttling\_burst\_limit) | (Optional) Throttling burst limit. | `number` | `-1` | no |
| <a name="input_throttling_rate_limit"></a> [throttling\_rate\_limit](#input\_throttling\_rate\_limit) | (Optional) Throttling rate limit. | `number` | `-1` | no |
| <a name="input_xray_tracing_enabled"></a> [xray\_tracing\_enabled](#input\_xray\_tracing\_enabled) | (Optional) Whether X-Ray tracing is enabled. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_log_group_arn"></a> [access\_log\_group\_arn](#output\_access\_log\_group\_arn) | The ARN of the CloudWatch log group for API access logs. |
| <a name="output_rest_api_arn"></a> [rest\_api\_arn](#output\_rest\_api\_arn) | The ARN of the REST API. |
| <a name="output_rest_api_execution_arn"></a> [rest\_api\_execution\_arn](#output\_rest\_api\_execution\_arn) | The execution ARN of the REST API. |
| <a name="output_rest_api_id"></a> [rest\_api\_id](#output\_rest\_api\_id) | The ID of the REST API. |
| <a name="output_rest_api_root_resource_id"></a> [rest\_api\_root\_resource\_id](#output\_rest\_api\_root\_resource\_id) | The root resource ID of the REST API. |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | The ARN of the stage. |
| <a name="output_stage_execution_arn"></a> [stage\_execution\_arn](#output\_stage\_execution\_arn) | The execution ARN of the stage. |
| <a name="output_stage_id"></a> [stage\_id](#output\_stage\_id) | The ID of the stage. |
| <a name="output_stage_invoke_url"></a> [stage\_invoke\_url](#output\_stage\_invoke\_url) | The URL to invoke the API. |
