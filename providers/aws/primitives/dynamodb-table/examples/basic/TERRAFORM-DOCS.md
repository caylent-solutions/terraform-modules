<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb_table"></a> [dynamodb\_table](#module\_dynamodb\_table) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Attribute to use as the hash (partition) key | `string` | `"pk"` | no |
| <a name="input_hash_key_type"></a> [hash\_key\_type](#input\_hash\_key\_type) | Attribute type for the hash key. Valid values: S, N, B | `string` | `"S"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the DynamoDB table | `string` | n/a | yes |
| <a name="input_point_in_time_recovery_enabled"></a> [point\_in\_time\_recovery\_enabled](#input\_point\_in\_time\_recovery\_enabled) | Whether to enable point-in-time recovery for the table | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the DynamoDB table | `map(string)` | `{}` | no |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | Name of the TTL attribute | `string` | `"ttl"` | no |
| <a name="input_ttl_enabled"></a> [ttl\_enabled](#input\_ttl\_enabled) | Whether to enable time-to-live on the table | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | The ARN of the DynamoDB table |
| <a name="output_table_billing_mode"></a> [table\_billing\_mode](#output\_table\_billing\_mode) | The billing mode of the DynamoDB table |
| <a name="output_table_hash_key"></a> [table\_hash\_key](#output\_table\_hash\_key) | The hash key of the DynamoDB table |
| <a name="output_table_id"></a> [table\_id](#output\_table\_id) | The name/ID of the DynamoDB table |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | The name of the DynamoDB table |
| <a name="output_table_stream_arn"></a> [table\_stream\_arn](#output\_table\_stream\_arn) | The ARN of the Table Stream |
| <a name="output_table_tags_all"></a> [table\_tags\_all](#output\_table\_tags\_all) | All tags assigned to the table |
<!-- END_TF_DOCS -->
