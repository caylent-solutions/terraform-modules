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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_api_gateway_base_path_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_api_gateway_method_settings.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_rest_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_usage_plan.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input__method_path_all"></a> [\_method\_path\_all](#input\_\_method\_path\_all) | AWS API constant: method path wildcard for all methods and resources. | `string` | `"*/*"` | no |
| <a name="input_access_log_destination_arn"></a> [access\_log\_destination\_arn](#input\_access\_log\_destination\_arn) | (Required) ARN of the CloudWatch log group or Kinesis Data Firehose delivery stream to receive access logs. | `string` | n/a | yes |
| <a name="input_access_log_format"></a> [access\_log\_format](#input\_access\_log\_format) | (Optional) Formatting and values recorded in the access logs. Defaults to a standard JSON format including requestId, ip, caller, user, requestTime, httpMethod, resourcePath, status, protocol, and responseLength. | `string` | `"{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"caller\":\"$context.identity.caller\",\"user\":\"$context.identity.user\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\",\"status\":\"$context.status\",\"protocol\":\"$context.protocol\",\"responseLength\":\"$context.responseLength\"}"` | no |
| <a name="input_api_key_source"></a> [api\_key\_source](#input\_api\_key\_source) | (Optional) Source of the API key for requests. Valid values: HEADER, AUTHORIZER. | `string` | `"HEADER"` | no |
| <a name="input_base_path"></a> [base\_path](#input\_base\_path) | (Optional) Base path to map to the REST API stage when using a custom domain. | `string` | `null` | no |
| <a name="input_binary_media_types"></a> [binary\_media\_types](#input\_binary\_media\_types) | (Optional) List of binary media types supported by the REST API. | `list(string)` | `[]` | no |
| <a name="input_cache_cluster_enabled"></a> [cache\_cluster\_enabled](#input\_cache\_cluster\_enabled) | (Optional) Whether a cache cluster is enabled for the stage. | `bool` | `false` | no |
| <a name="input_cache_cluster_size"></a> [cache\_cluster\_size](#input\_cache\_cluster\_size) | (Optional) Size of the cache cluster for the stage, if enabled. Valid values: 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118, 237. | `string` | `"0.5"` | no |
| <a name="input_cache_data_encrypted"></a> [cache\_data\_encrypted](#input\_cache\_data\_encrypted) | (Optional) Whether the cached responses are encrypted. Defaults to true for security compliance. | `bool` | `true` | no |
| <a name="input_cache_enabled"></a> [cache\_enabled](#input\_cache\_enabled) | (Optional) Whether response caching is enabled in method settings. Defaults to true to improve API performance and reduce backend load. | `bool` | `true` | no |
| <a name="input_cloudwatch_logs_role_arn"></a> [cloudwatch\_logs\_role\_arn](#input\_cloudwatch\_logs\_role\_arn) | (Optional) ARN of an IAM role for pushing logs from API Gateway to CloudWatch. Required when access\_log\_destination\_arn is set. | `string` | `null` | no |
| <a name="input_data_trace_enabled"></a> [data\_trace\_enabled](#input\_data\_trace\_enabled) | (Optional) Whether data trace logging is enabled for the default route. Has no effect when logging\_level is OFF. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Description of the REST API. | `string` | `""` | no |
| <a name="input_domain_certificate_arn"></a> [domain\_certificate\_arn](#input\_domain\_certificate\_arn) | (Optional) ARN of an ACM certificate to use for the custom domain. Required when domain\_name is set. | `string` | `null` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | (Optional) Custom domain name for the REST API. When set, a domain name mapping and base path mapping are created. | `string` | `null` | no |
| <a name="input_domain_security_policy"></a> [domain\_security\_policy](#input\_domain\_security\_policy) | (Optional) TLS security policy for the custom domain. Only TLS\_1\_2 is supported. | `string` | `"TLS_1_2"` | no |
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | (Optional) Endpoint type for the REST API. Valid values: EDGE, REGIONAL, PRIVATE. | `string` | `"REGIONAL"` | no |
| <a name="input_logging_level"></a> [logging\_level](#input\_logging\_level) | (Optional) Logging level for execution logs. Valid values: OFF, ERROR, INFO. | `string` | `"OFF"` | no |
| <a name="input_managed_by_tag"></a> [managed\_by\_tag](#input\_managed\_by\_tag) | (Optional) Value for the ManagedBy tag. | `string` | `"terraform"` | no |
| <a name="input_metrics_enabled"></a> [metrics\_enabled](#input\_metrics\_enabled) | (Optional) Whether detailed metrics are enabled for the default route. | `bool` | `false` | no |
| <a name="input_minimum_compression_size"></a> [minimum\_compression\_size](#input\_minimum\_compression\_size) | (Optional) Minimum response size to compress for the REST API. -1 disables compression. Value between -1 and 10485760 (10 MB). | `number` | `-1` | no |
| <a name="input_module_tag"></a> [module\_tag](#input\_module\_tag) | (Optional) Value for the Module tag. | `string` | `"api-gateway-rest-api"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name for the REST API and associated resources. | `string` | n/a | yes |
| <a name="input_stage_description"></a> [stage\_description](#input\_stage\_description) | (Optional) Description of the stage. | `string` | `""` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | (Required) Name of the stage to deploy the REST API to. | `string` | n/a | yes |
| <a name="input_stage_variables"></a> [stage\_variables](#input\_stage\_variables) | (Optional) Map defining stage variables. | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_throttling_burst_limit"></a> [throttling\_burst\_limit](#input\_throttling\_burst\_limit) | (Optional) Throttling burst limit for the stage default method settings. | `number` | `-1` | no |
| <a name="input_throttling_rate_limit"></a> [throttling\_rate\_limit](#input\_throttling\_rate\_limit) | (Optional) Throttling rate limit for the stage default method settings. | `number` | `-1` | no |
| <a name="input_usage_plan_description"></a> [usage\_plan\_description](#input\_usage\_plan\_description) | (Optional) Description of the usage plan. | `string` | `""` | no |
| <a name="input_usage_plan_name"></a> [usage\_plan\_name](#input\_usage\_plan\_name) | (Optional) Name for an associated usage plan. When set, a usage plan is created and associated with the stage. | `string` | `null` | no |
| <a name="input_usage_plan_quota_limit"></a> [usage\_plan\_quota\_limit](#input\_usage\_plan\_quota\_limit) | (Optional) Maximum number of requests that can be made in a given time period for the usage plan. | `number` | `null` | no |
| <a name="input_usage_plan_quota_offset"></a> [usage\_plan\_quota\_offset](#input\_usage\_plan\_quota\_offset) | (Optional) Number of requests subtracted from the given limit in the initial time period for the usage plan. | `number` | `0` | no |
| <a name="input_usage_plan_quota_period"></a> [usage\_plan\_quota\_period](#input\_usage\_plan\_quota\_period) | (Optional) Time period in which the limit applies. Valid values: DAY, WEEK, MONTH. | `string` | `null` | no |
| <a name="input_usage_plan_throttle_burst_limit"></a> [usage\_plan\_throttle\_burst\_limit](#input\_usage\_plan\_throttle\_burst\_limit) | (Optional) Throttle burst limit for the usage plan. | `number` | `null` | no |
| <a name="input_usage_plan_throttle_rate_limit"></a> [usage\_plan\_throttle\_rate\_limit](#input\_usage\_plan\_throttle\_rate\_limit) | (Optional) Throttle rate limit for the usage plan. | `number` | `null` | no |
| <a name="input_web_acl_arn"></a> [web\_acl\_arn](#input\_web\_acl\_arn) | (Optional) ARN of a WAFv2 Web ACL to associate with the stage. | `string` | `null` | no |
| <a name="input_xray_tracing_enabled"></a> [xray\_tracing\_enabled](#input\_xray\_tracing\_enabled) | (Optional) Whether active tracing with X-Ray is enabled for the stage. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_id"></a> [deployment\_id](#output\_deployment\_id) | The ID of the API deployment. |
| <a name="output_domain_name_arn"></a> [domain\_name\_arn](#output\_domain\_name\_arn) | The ARN of the custom domain name. |
| <a name="output_domain_name_id"></a> [domain\_name\_id](#output\_domain\_name\_id) | The internal ID assigned to the custom domain name resource. |
| <a name="output_domain_regional_domain_name"></a> [domain\_regional\_domain\_name](#output\_domain\_regional\_domain\_name) | The hostname for the custom domain's regional endpoint. |
| <a name="output_domain_regional_zone_id"></a> [domain\_regional\_zone\_id](#output\_domain\_regional\_zone\_id) | The hosted zone ID that can be used to create an Alias record pointing to the regional endpoint. |
| <a name="output_rest_api_arn"></a> [rest\_api\_arn](#output\_rest\_api\_arn) | The ARN of the REST API. |
| <a name="output_rest_api_execution_arn"></a> [rest\_api\_execution\_arn](#output\_rest\_api\_execution\_arn) | The execution ARN part to be used in lambda\_permission's source\_arn. |
| <a name="output_rest_api_id"></a> [rest\_api\_id](#output\_rest\_api\_id) | The ID of the REST API. |
| <a name="output_rest_api_root_resource_id"></a> [rest\_api\_root\_resource\_id](#output\_rest\_api\_root\_resource\_id) | The resource ID of the REST API's root resource. |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | The ARN of the stage. |
| <a name="output_stage_execution_arn"></a> [stage\_execution\_arn](#output\_stage\_execution\_arn) | The execution ARN to be used in lambda\_permission's source\_arn when allowing API Gateway to invoke a Lambda function. |
| <a name="output_stage_id"></a> [stage\_id](#output\_stage\_id) | The ID of the stage. |
| <a name="output_stage_invoke_url"></a> [stage\_invoke\_url](#output\_stage\_invoke\_url) | The URL to invoke the API pointing to the stage. |
| <a name="output_usage_plan_arn"></a> [usage\_plan\_arn](#output\_usage\_plan\_arn) | The ARN of the usage plan. |
| <a name="output_usage_plan_id"></a> [usage\_plan\_id](#output\_usage\_plan\_id) | The ID of the usage plan. |
