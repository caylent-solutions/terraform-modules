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
| <a name="module_api"></a> [api](#module\_api) | git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/api-gateway-rest-api | providers/aws/primitives/api-gateway-rest-api/v0.1.0 |
| <a name="module_custom_domain_record"></a> [custom\_domain\_record](#module\_custom\_domain\_record) | git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/route53-record | providers/aws/primitives/route53-record/v0.1.0 |
| <a name="module_lambda_authorizer"></a> [lambda\_authorizer](#module\_lambda\_authorizer) | git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/lambda | providers/aws/primitives/lambda/v0.1.0 |
| <a name="module_waf"></a> [waf](#module\_waf) | git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/waf-webacl | providers/aws/primitives/waf-webacl/v0.1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_access_log_destination_arn"></a> [api\_access\_log\_destination\_arn](#input\_api\_access\_log\_destination\_arn) | Externally provisioned access log destination ARN. When null and create\_access\_log\_group = true, an auto-managed log group is used. | `string` | `null` | no |
| <a name="input_api_access_log_kms_key_arn"></a> [api\_access\_log\_kms\_key\_arn](#input\_api\_access\_log\_kms\_key\_arn) | KMS CMK ARN used to encrypt the auto-managed stage access log group at rest. | `string` | `null` | no |
| <a name="input_api_access_log_retention_in_days"></a> [api\_access\_log\_retention\_in\_days](#input\_api\_access\_log\_retention\_in\_days) | Retention (days) for the auto-managed stage access log group. | `number` | `30` | no |
| <a name="input_api_cache_cluster_enabled"></a> [api\_cache\_cluster\_enabled](#input\_api\_cache\_cluster\_enabled) | Whether the stage's cache cluster is enabled (required for stage-level caching). | `bool` | `true` | no |
| <a name="input_api_cache_cluster_size"></a> [api\_cache\_cluster\_size](#input\_api\_cache\_cluster\_size) | Stage cache cluster size. | `string` | `"0.5"` | no |
| <a name="input_api_create_access_log_group"></a> [api\_create\_access\_log\_group](#input\_api\_create\_access\_log\_group) | Whether the primitive provisions a CloudWatch log group for stage access logs. | `bool` | `true` | no |
| <a name="input_api_description"></a> [api\_description](#input\_api\_description) | Description of the REST API. | `string` | `null` | no |
| <a name="input_api_endpoint_type"></a> [api\_endpoint\_type](#input\_api\_endpoint\_type) | API Gateway endpoint configuration. Locked to REGIONAL by the primitive. | `string` | `"REGIONAL"` | no |
| <a name="input_api_method_logging_level"></a> [api\_method\_logging\_level](#input\_api\_method\_logging\_level) | Method-level logging level. OFF, ERROR, or INFO. | `string` | `"INFO"` | no |
| <a name="input_api_method_metrics_enabled"></a> [api\_method\_metrics\_enabled](#input\_api\_method\_metrics\_enabled) | Whether per-method CloudWatch metrics are enabled. | `bool` | `true` | no |
| <a name="input_api_method_throttling_burst_limit"></a> [api\_method\_throttling\_burst\_limit](#input\_api\_method\_throttling\_burst\_limit) | Per-method throttling burst limit. | `number` | `5000` | no |
| <a name="input_api_method_throttling_rate_limit"></a> [api\_method\_throttling\_rate\_limit](#input\_api\_method\_throttling\_rate\_limit) | Per-method throttling steady-state rate limit (requests/second). | `number` | `10000` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | Name of the REST API. | `string` | n/a | yes |
| <a name="input_api_openapi_body"></a> [api\_openapi\_body](#input\_api\_openapi\_body) | OpenAPI 3.0 body (string) defining the REST API surface and integrations. The api-gateway-rest-api primitive imports this verbatim via body. | `string` | n/a | yes |
| <a name="input_api_stage_description"></a> [api\_stage\_description](#input\_api\_stage\_description) | Deployment stage description. | `string` | `null` | no |
| <a name="input_api_stage_name"></a> [api\_stage\_name](#input\_api\_stage\_name) | Deployment stage name. | `string` | `"prod"` | no |
| <a name="input_api_xray_tracing_enabled"></a> [api\_xray\_tracing\_enabled](#input\_api\_xray\_tracing\_enabled) | Whether X-Ray tracing is enabled on the stage. | `bool` | `true` | no |
| <a name="input_authorizer_description"></a> [authorizer\_description](#input\_authorizer\_description) | Description of the authorizer Lambda function. | `string` | `"HMAC-SHA256 authorizer for the telemetry API"` | no |
| <a name="input_authorizer_environment"></a> [authorizer\_environment](#input\_authorizer\_environment) | Plain (non-secret) environment variables for the authorizer Lambda. | `map(string)` | `{}` | no |
| <a name="input_authorizer_filename"></a> [authorizer\_filename](#input\_authorizer\_filename) | Path to the local Zip artifact containing the authorizer source. Mutually exclusive with authorizer\_s3\_bucket/authorizer\_s3\_key and authorizer\_image\_uri. | `string` | `null` | no |
| <a name="input_authorizer_function_name"></a> [authorizer\_function\_name](#input\_authorizer\_function\_name) | Name of the HMAC-SHA256 authorizer Lambda function. | `string` | n/a | yes |
| <a name="input_authorizer_handler"></a> [authorizer\_handler](#input\_authorizer\_handler) | Authorizer handler entrypoint (Zip package only). | `string` | `null` | no |
| <a name="input_authorizer_image_uri"></a> [authorizer\_image\_uri](#input\_authorizer\_image\_uri) | ECR image URI for the authorizer (only when package\_type = Image). | `string` | `null` | no |
| <a name="input_authorizer_memory_size"></a> [authorizer\_memory\_size](#input\_authorizer\_memory\_size) | Authorizer Lambda memory size in MB. | `number` | `256` | no |
| <a name="input_authorizer_package_type"></a> [authorizer\_package\_type](#input\_authorizer\_package\_type) | Lambda packaging type. Zip or Image. | `string` | `"Zip"` | no |
| <a name="input_authorizer_role_arn"></a> [authorizer\_role\_arn](#input\_authorizer\_role\_arn) | IAM role ARN the authorizer Lambda assumes (must allow lambda.amazonaws.com to AssumeRole and grant CloudWatch Logs writes). | `string` | n/a | yes |
| <a name="input_authorizer_runtime"></a> [authorizer\_runtime](#input\_authorizer\_runtime) | Authorizer Lambda runtime (Zip package only). | `string` | `null` | no |
| <a name="input_authorizer_s3_bucket"></a> [authorizer\_s3\_bucket](#input\_authorizer\_s3\_bucket) | S3 bucket holding the authorizer Zip artifact. | `string` | `null` | no |
| <a name="input_authorizer_s3_key"></a> [authorizer\_s3\_key](#input\_authorizer\_s3\_key) | S3 key for the authorizer Zip artifact. | `string` | `null` | no |
| <a name="input_authorizer_timeout"></a> [authorizer\_timeout](#input\_authorizer\_timeout) | Authorizer Lambda execution timeout in seconds. | `number` | `5` | no |
| <a name="input_custom_domain_base_path"></a> [custom\_domain\_base\_path](#input\_custom\_domain\_base\_path) | Optional base path mapping for the custom domain (null means root). | `string` | `null` | no |
| <a name="input_custom_domain_certificate_arn"></a> [custom\_domain\_certificate\_arn](#input\_custom\_domain\_certificate\_arn) | ACM certificate ARN used by the custom domain. Required when custom\_domain\_name is set. | `string` | `null` | no |
| <a name="input_custom_domain_name"></a> [custom\_domain\_name](#input\_custom\_domain\_name) | Custom domain name attached to the REST API. When null, no custom domain or DNS alias record is created. | `string` | `null` | no |
| <a name="input_custom_domain_security_policy"></a> [custom\_domain\_security\_policy](#input\_custom\_domain\_security\_policy) | TLS security policy for the custom domain (TLS\_1\_2 recommended). | `string` | `"TLS_1_2"` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 hosted zone id where the alias record is created. Required when custom\_domain\_name is set. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all module-managed resources. | `map(string)` | `{}` | no |
| <a name="input_web_acl_cloudwatch_metrics_enabled"></a> [web\_acl\_cloudwatch\_metrics\_enabled](#input\_web\_acl\_cloudwatch\_metrics\_enabled) | Whether CloudWatch metrics are enabled for the Web ACL and its rules. | `bool` | `true` | no |
| <a name="input_web_acl_create_log_group"></a> [web\_acl\_create\_log\_group](#input\_web\_acl\_create\_log\_group) | Whether to create a CloudWatch log group for WAF logs (only when web\_acl\_logging\_enabled = true and no log\_destination\_arn is supplied). | `bool` | `true` | no |
| <a name="input_web_acl_default_action"></a> [web\_acl\_default\_action](#input\_web\_acl\_default\_action) | Default action for unmatched requests. allow or block. | `string` | `"allow"` | no |
| <a name="input_web_acl_description"></a> [web\_acl\_description](#input\_web\_acl\_description) | Description of the Web ACL. | `string` | `null` | no |
| <a name="input_web_acl_log_destination_arn"></a> [web\_acl\_log\_destination\_arn](#input\_web\_acl\_log\_destination\_arn) | Externally provisioned WAF log destination ARN. When null, an auto-managed CloudWatch log group is used. | `string` | `null` | no |
| <a name="input_web_acl_log_kms_key_arn"></a> [web\_acl\_log\_kms\_key\_arn](#input\_web\_acl\_log\_kms\_key\_arn) | KMS CMK ARN used to encrypt the auto-managed WAF log group at rest. | `string` | `null` | no |
| <a name="input_web_acl_log_retention_in_days"></a> [web\_acl\_log\_retention\_in\_days](#input\_web\_acl\_log\_retention\_in\_days) | Retention (days) for the auto-managed WAF log group. | `number` | `30` | no |
| <a name="input_web_acl_logging_enabled"></a> [web\_acl\_logging\_enabled](#input\_web\_acl\_logging\_enabled) | Whether to enable WAF logging. | `bool` | `true` | no |
| <a name="input_web_acl_managed_rule_groups"></a> [web\_acl\_managed\_rule\_groups](#input\_web\_acl\_managed\_rule\_groups) | AWS Managed Rule Groups to attach to the Web ACL. | <pre>list(object({<br/>    name     = string<br/>    priority = number<br/>    override = optional(string, "none")<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "AWSManagedRulesCommonRuleSet",<br/>    "override": "none",<br/>    "priority": 10<br/>  },<br/>  {<br/>    "name": "AWSManagedRulesKnownBadInputsRuleSet",<br/>    "override": "none",<br/>    "priority": 20<br/>  },<br/>  {<br/>    "name": "AWSManagedRulesAmazonIpReputationList",<br/>    "override": "none",<br/>    "priority": 30<br/>  }<br/>]</pre> | no |
| <a name="input_web_acl_name"></a> [web\_acl\_name](#input\_web\_acl\_name) | Name of the WAF Web ACL fronting the telemetry API. | `string` | n/a | yes |
| <a name="input_web_acl_rate_limit_per_header"></a> [web\_acl\_rate\_limit\_per\_header](#input\_web\_acl\_rate\_limit\_per\_header) | Per-header rate-based rule (5-min sliding window) keyed by HTTP header name. Null disables this rule. | <pre>object({<br/>    priority    = number<br/>    limit       = number<br/>    header_name = string<br/>  })</pre> | `null` | no |
| <a name="input_web_acl_rate_limit_per_ip"></a> [web\_acl\_rate\_limit\_per\_ip](#input\_web\_acl\_rate\_limit\_per\_ip) | Per-IP rate-based rule (5-min sliding window). Null disables this rule. | <pre>object({<br/>    priority = number<br/>    limit    = number<br/>  })</pre> | <pre>{<br/>  "limit": 2000,<br/>  "priority": 100<br/>}</pre> | no |
| <a name="input_web_acl_sampled_requests_enabled"></a> [web\_acl\_sampled\_requests\_enabled](#input\_web\_acl\_sampled\_requests\_enabled) | Whether sampled requests collection is enabled for the Web ACL and its rules. | `bool` | `true` | no |
| <a name="input_web_acl_scope"></a> [web\_acl\_scope](#input\_web\_acl\_scope) | Scope of the Web ACL. REGIONAL for API Gateway, CLOUDFRONT only when fronting CloudFront (must be us-east-1). | `string` | `"REGIONAL"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_invoke_url"></a> [api\_invoke\_url](#output\_api\_invoke\_url) | Invocation URL of the REST API stage on the default execute-api endpoint. |
| <a name="output_authorizer_function_arn"></a> [authorizer\_function\_arn](#output\_authorizer\_function\_arn) | ARN of the authorizer Lambda function (for granting api-gateway invoke permissions). |
| <a name="output_authorizer_function_name"></a> [authorizer\_function\_name](#output\_authorizer\_function\_name) | Name of the HMAC-SHA256 authorizer Lambda function. |
| <a name="output_authorizer_invoke_arn"></a> [authorizer\_invoke\_arn](#output\_authorizer\_invoke\_arn) | Invoke ARN of the authorizer Lambda (for `x-amazon-apigateway-authorizer.authorizerUri`). |
| <a name="output_custom_domain_name"></a> [custom\_domain\_name](#output\_custom\_domain\_name) | Custom domain name attached to the REST API, or null when not configured. |
| <a name="output_custom_domain_record_fqdn"></a> [custom\_domain\_record\_fqdn](#output\_custom\_domain\_record\_fqdn) | FQDN of the alias record routing the custom domain at the API, or null when not configured. |
| <a name="output_custom_domain_regional_domain_name"></a> [custom\_domain\_regional\_domain\_name](#output\_custom\_domain\_regional\_domain\_name) | Regional domain name created for the custom domain, or null when custom\_domain\_name is not set. |
| <a name="output_custom_domain_regional_zone_id"></a> [custom\_domain\_regional\_zone\_id](#output\_custom\_domain\_regional\_zone\_id) | Regional zone ID for the custom domain, or null when not set. |
| <a name="output_rest_api_execution_arn"></a> [rest\_api\_execution\_arn](#output\_rest\_api\_execution\_arn) | Execution ARN prefix used for granting `lambda:InvokeFunction` permissions to API Gateway. |
| <a name="output_rest_api_id"></a> [rest\_api\_id](#output\_rest\_api\_id) | ID of the REST API (used for granting WAF association and lambda permissions in the consumer). |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | ARN of the deployment stage (used by the consumer to attach `aws_wafv2_web_acl_association`). |
| <a name="output_stage_name"></a> [stage\_name](#output\_stage\_name) | Name of the deployment stage. |
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | ARN of the WAF Web ACL fronting the API. |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | ID of the WAF Web ACL. |
