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
| <a name="module_table"></a> [table](#module\_table) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | List of attribute definitions. | <pre>list(object({<br/>    name = string<br/>    type = string<br/>  }))</pre> | n/a | yes |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Billing mode. | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enable deletion protection. | `bool` | `false` | no |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | Global Secondary Indexes. | `any` | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Partition key attribute name. | `string` | n/a | yes |
| <a name="input_point_in_time_recovery_enabled"></a> [point\_in\_time\_recovery\_enabled](#input\_point\_in\_time\_recovery\_enabled) | Enable PITR. | `bool` | `true` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | Sort key attribute name (optional). | `string` | `null` | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Enable DynamoDB Streams. | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | Stream view type. | `string` | `"NEW_AND_OLD_IMAGES"` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Base name of the table (a random suffix is appended for test isolation). | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the table. | `map(string)` | `{}` | no |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | TTL attribute name (null disables). | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_stream_arn"></a> [stream\_arn](#output\_stream\_arn) | ARN of the DynamoDB Streams endpoint, or null when stream\_enabled = false. |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | ARN of the DynamoDB table. |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | Name of the DynamoDB table. |
<!-- END_TF_DOCS -->