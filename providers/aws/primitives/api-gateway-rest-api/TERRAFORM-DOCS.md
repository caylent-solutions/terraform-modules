## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_base_path_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_api_gateway_method_settings.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_rest_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_usage_plan.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan) | resource |
| [aws_cloudwatch_log_group.stage_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_destination_arn"></a> [access\_log\_destination\_arn](#input\_access\_log\_destination\_arn) | ARN of an existing CloudWatch Log Group, Kinesis Firehose, or Kinesis stream to receive access logs. When null and create\_access\_log\_group = true, the module creates a Log Group. | `string` | `null` | no |
| <a name="input_access_log_format"></a> [access\_log\_format](#input\_access\_log\_format) | Access log format. Default is the standard JSON format containing requestId, sourceIp, requestTime, httpMethod, resourcePath, status, protocol, and responseLength. | `string` | `"{\"requestId\":\"$context.requestId\",\"sourceIp\":\"$context.identity.sourceIp\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\",\"status\":\"$context.status\",\"protocol\":\"$context.protocol\",\"responseLength\":\"$context.responseLength\"}"` | no |
| <a name="input_access_log_kms_key_arn"></a> [access\_log\_kms\_key\_arn](#input\_access\_log\_kms\_key\_arn) | KMS key ARN to encrypt the auto-created access log group. Null uses AWS-managed encryption. | `string` | `null` | no |
| <a name="input_access_log_retention_in_days"></a> [access\_log\_retention\_in\_days](#input\_access\_log\_retention\_in\_days) | Retention for the auto-created access log group (only used when create\_access\_log\_group = true). | `number` | `30` | no |
| <a name="input_api_key_source"></a> [api\_key\_source](#input\_api\_key\_source) | Source of the API key for metering requests. HEADER (X-API-Key) or AUTHORIZER. | `string` | `"HEADER"` | no |
| <a name="input_binary_media_types"></a> [binary\_media\_types](#input\_binary\_media\_types) | List of MIME types that should be treated as binary by API Gateway. | `list(string)` | `[]` | no |
| <a name="input_cache_cluster_enabled"></a> [cache\_cluster\_enabled](#input\_cache\_cluster\_enabled) | Enable an API Gateway response cache for the stage. | `bool` | `false` | no |
| <a name="input_cache_cluster_size"></a> [cache\_cluster\_size](#input\_cache\_cluster\_size) | Cache size in GB. Valid: 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118, 237. | `string` | `"0.5"` | no |
| <a name="input_create_access_log_group"></a> [create\_access\_log\_group](#input\_create\_access\_log\_group) | Create a CloudWatch Log Group for stage access logs (used when access\_log\_destination\_arn is not provided). | `bool` | `false` | no |
| <a name="input_create_usage_plan"></a> [create\_usage\_plan](#input\_create\_usage\_plan) | Create an API Gateway usage plan that targets this stage. | `bool` | `false` | no |
| <a name="input_custom_domain_base_path"></a> [custom\_domain\_base\_path](#input\_custom\_domain\_base\_path) | Base path for the custom-domain mapping. Empty string maps to the root of the custom domain. | `string` | `""` | no |
| <a name="input_custom_domain_certificate_arn"></a> [custom\_domain\_certificate\_arn](#input\_custom\_domain\_certificate\_arn) | ACM certificate ARN for the custom domain. Required when custom\_domain\_name is set; the certificate must be in the same region as the API for REGIONAL endpoints. | `string` | `null` | no |
| <a name="input_custom_domain_name"></a> [custom\_domain\_name](#input\_custom\_domain\_name) | Custom domain name to attach to the API. When null, no custom domain or base-path mapping is created. | `string` | `null` | no |
| <a name="input_custom_domain_security_policy"></a> [custom\_domain\_security\_policy](#input\_custom\_domain\_security\_policy) | Minimum TLS version for the custom domain. TLS\_1\_2 (recommended) or TLS\_1\_0. | `string` | `"TLS_1_2"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the REST API. | `string` | `null` | no |
| <a name="input_disable_execute_api_endpoint"></a> [disable\_execute\_api\_endpoint](#input\_disable\_execute\_api\_endpoint) | Disable the default `*.execute-api.<region>.amazonaws.com` endpoint and force callers through the custom domain. | `bool` | `false` | no |
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | API Gateway endpoint type. One of REGIONAL, EDGE, or PRIVATE. | `string` | `"REGIONAL"` | no |
| <a name="input_method_data_trace_enabled"></a> [method\_data\_trace\_enabled](#input\_method\_data\_trace\_enabled) | Enable full request/response logging at INFO level. Useful for debugging; not recommended for production. | `bool` | `false` | no |
| <a name="input_method_logging_level"></a> [method\_logging\_level](#input\_method\_logging\_level) | API Gateway logging level for all methods. OFF, ERROR, or INFO. | `string` | `"ERROR"` | no |
| <a name="input_method_metrics_enabled"></a> [method\_metrics\_enabled](#input\_method\_metrics\_enabled) | Enable detailed CloudWatch metrics for all methods on the stage. | `bool` | `true` | no |
| <a name="input_method_throttling_burst_limit"></a> [method\_throttling\_burst\_limit](#input\_method\_throttling\_burst\_limit) | Default burst limit (requests/sec spike capacity) for all methods on the stage. | `number` | `5000` | no |
| <a name="input_method_throttling_rate_limit"></a> [method\_throttling\_rate\_limit](#input\_method\_throttling\_rate\_limit) | Default sustained rate limit (requests/sec) for all methods on the stage. | `number` | `10000` | no |
| <a name="input_minimum_compression_size"></a> [minimum\_compression\_size](#input\_minimum\_compression\_size) | Minimum response size to enable compression, in bytes. -1 disables compression. | `number` | `-1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the REST API. | `string` | n/a | yes |
| <a name="input_openapi_body"></a> [openapi\_body](#input\_openapi\_body) | Optional OpenAPI 3.0 body that defines the API. When null, the API is created without inline definitions and consumers add resources/methods/integrations separately. | `string` | `null` | no |
| <a name="input_stage_description"></a> [stage\_description](#input\_stage\_description) | Description of the deployment stage. | `string` | `null` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | Name of the deployment stage (e.g., prod, dev, v1). | `string` | `"v1"` | no |
| <a name="input_stage_variables"></a> [stage\_variables](#input\_stage\_variables) | Map of stage-variable name to value. Available to integrations as ${stageVariables.NAME}. | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the REST API and stage (and to derived resources where supported). | `map(string)` | `{}` | no |
| <a name="input_usage_plan_description"></a> [usage\_plan\_description](#input\_usage\_plan\_description) | Description for the usage plan. | `string` | `null` | no |
| <a name="input_usage_plan_quota"></a> [usage\_plan\_quota](#input\_usage\_plan\_quota) | Quota settings for the usage plan: { limit, offset (optional), period (DAY\|WEEK\|MONTH) }. Null disables plan-level quotas. | <pre>object({<br/>    limit  = number<br/>    offset = optional(number)<br/>    period = string<br/>  })</pre> | `null` | no |
| <a name="input_usage_plan_throttle"></a> [usage\_plan\_throttle](#input\_usage\_plan\_throttle) | Throttle settings for the usage plan: { burst\_limit, rate\_limit }. Null disables plan-level throttling. | <pre>object({<br/>    burst_limit = number<br/>    rate_limit  = number<br/>  })</pre> | `null` | no |
| <a name="input_xray_tracing_enabled"></a> [xray\_tracing\_enabled](#input\_xray\_tracing\_enabled) | Enable AWS X-Ray tracing on the stage. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_log_group_arn"></a> [access\_log\_group\_arn](#output\_access\_log\_group\_arn) | ARN of the auto-created access log group, or null when create\_access\_log\_group is false. |
| <a name="output_custom_domain_regional_domain_name"></a> [custom\_domain\_regional\_domain\_name](#output\_custom\_domain\_regional\_domain\_name) | Regional domain name created for the custom domain, or null when custom\_domain\_name is not set. |
| <a name="output_custom_domain_regional_zone_id"></a> [custom\_domain\_regional\_zone\_id](#output\_custom\_domain\_regional\_zone\_id) | Regional zone ID for the custom domain (used for Route53 alias records), or null when not set. |
| <a name="output_deployment_id"></a> [deployment\_id](#output\_deployment\_id) | ID of the deployment associated with the stage. |
| <a name="output_rest_api_arn"></a> [rest\_api\_arn](#output\_rest\_api\_arn) | ARN of the REST API. |
| <a name="output_rest_api_execution_arn"></a> [rest\_api\_execution\_arn](#output\_rest\_api\_execution\_arn) | Execution ARN prefix used for granting `lambda:InvokeFunction` permissions to API Gateway. |
| <a name="output_rest_api_id"></a> [rest\_api\_id](#output\_rest\_api\_id) | ID of the REST API. |
| <a name="output_rest_api_root_resource_id"></a> [rest\_api\_root\_resource\_id](#output\_rest\_api\_root\_resource\_id) | Resource ID of the REST API's root (`/`) resource. |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | ARN of the deployment stage. |
| <a name="output_stage_invoke_url"></a> [stage\_invoke\_url](#output\_stage\_invoke\_url) | Invocation URL of the deployment stage on the default execute-api endpoint. |
| <a name="output_stage_name"></a> [stage\_name](#output\_stage\_name) | Name of the deployment stage. |
| <a name="output_usage_plan_id"></a> [usage\_plan\_id](#output\_usage\_plan\_id) | ID of the usage plan, or null when create\_usage\_plan is false. |
