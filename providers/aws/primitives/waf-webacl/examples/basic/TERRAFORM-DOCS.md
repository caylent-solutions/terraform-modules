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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_webacl"></a> [webacl](#module\_webacl) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | Default action for unmatched requests. | `string` | `"allow"` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | WAF log group retention. | `number` | `7` | no |
| <a name="input_rate_limit_header_name"></a> [rate\_limit\_header\_name](#input\_rate\_limit\_header\_name) | Header name to aggregate the per-header rate-limit on. | `string` | `"x-caylent-tool"` | no |
| <a name="input_rate_limit_per_header"></a> [rate\_limit\_per\_header](#input\_rate\_limit\_per\_header) | Per-header rate limit (5-min sliding window). | `number` | `1000` | no |
| <a name="input_rate_limit_per_ip"></a> [rate\_limit\_per\_ip](#input\_rate\_limit\_per\_ip) | Per-IP rate limit (5-min sliding window). | `number` | `2000` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | WAF scope (REGIONAL or CLOUDFRONT). | `string` | `"REGIONAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_webacl_name"></a> [webacl\_name](#input\_webacl\_name) | Base Web ACL name (a random suffix is appended). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | WAF log group ARN. |
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | ARN of the Web ACL. |
| <a name="output_web_acl_capacity"></a> [web\_acl\_capacity](#output\_web\_acl\_capacity) | Web ACL capacity units consumed. |
| <a name="output_web_acl_name"></a> [web\_acl\_name](#output\_web\_acl\_name) | Name of the Web ACL. |
<!-- END_TF_DOCS -->