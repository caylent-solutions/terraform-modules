# Basic Example Documentation

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_telemetry_api"></a> [telemetry\_api](#module\_telemetry\_api) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.authorizer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.authorizer_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.authorizer](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.lambda_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | Base name for the REST API; the example appends a random suffix. | `string` | `"test-telemetry-api"` | no |
| <a name="input_api_stage_name"></a> [api\_stage\_name](#input\_api\_stage\_name) | Deployment stage name. | `string` | `"prod"` | no |
| <a name="input_authorizer_function_name"></a> [authorizer\_function\_name](#input\_authorizer\_function\_name) | Base name for the HMAC-SHA256 authorizer Lambda; the example appends a random suffix. | `string` | `"test-telemetry-authz"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to module-managed resources. | `map(string)` | <pre>{<br/>  "Example": "basic",<br/>  "ManagedBy": "terraform",<br/>  "Module": "telemetry-api"<br/>}</pre> | no |
| <a name="input_web_acl_name"></a> [web\_acl\_name](#input\_web\_acl\_name) | Base name for the WAF Web ACL fronting the API; the example appends a random suffix. | `string` | `"test-telemetry-waf"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_invoke_url"></a> [api\_invoke\_url](#output\_api\_invoke\_url) | Invocation URL of the API Gateway stage. |
| <a name="output_authorizer_function_arn"></a> [authorizer\_function\_arn](#output\_authorizer\_function\_arn) | Authorizer Lambda function ARN. |
| <a name="output_authorizer_function_name"></a> [authorizer\_function\_name](#output\_authorizer\_function\_name) | Authorizer Lambda function name. |
| <a name="output_custom_domain_name"></a> [custom\_domain\_name](#output\_custom\_domain\_name) | Custom domain name attached to the REST API (null for the basic example). |
| <a name="output_rest_api_id"></a> [rest\_api\_id](#output\_rest\_api\_id) | ID of the REST API. |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | Stage ARN (used for WAF association in the consumer). |
| <a name="output_stage_name"></a> [stage\_name](#output\_stage\_name) | Stage name of the deployed API. |
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | ARN of the WAF Web ACL fronting the API. |
