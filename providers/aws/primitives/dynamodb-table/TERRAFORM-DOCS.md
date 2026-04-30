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
| [aws_appautoscaling_policy.table_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.table_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.table_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appautoscaling_target.table_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | List of attribute definitions for keys and indexes. Each attribute is `{ name = string, type = "S"|"N"|"B" }`. | <pre>list(object({<br/>    name = string<br/>    type = string<br/>  }))</pre> | `[]` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | Enable Application Auto Scaling on the table's read/write capacity. PROVISIONED billing only. | `bool` | `false` | no |
| <a name="input_autoscaling_read_max_capacity"></a> [autoscaling\_read\_max\_capacity](#input\_autoscaling\_read\_max\_capacity) | Maximum read capacity when autoscaling\_enabled = true. | `number` | `100` | no |
| <a name="input_autoscaling_read_min_capacity"></a> [autoscaling\_read\_min\_capacity](#input\_autoscaling\_read\_min\_capacity) | Minimum read capacity when autoscaling\_enabled = true. | `number` | `5` | no |
| <a name="input_autoscaling_target_utilization"></a> [autoscaling\_target\_utilization](#input\_autoscaling\_target\_utilization) | Target utilization percentage for the table-level read/write autoscaling policies. | `number` | `70` | no |
| <a name="input_autoscaling_write_max_capacity"></a> [autoscaling\_write\_max\_capacity](#input\_autoscaling\_write\_max\_capacity) | Maximum write capacity when autoscaling\_enabled = true. | `number` | `100` | no |
| <a name="input_autoscaling_write_min_capacity"></a> [autoscaling\_write\_min\_capacity](#input\_autoscaling\_write\_min\_capacity) | Minimum write capacity when autoscaling\_enabled = true. | `number` | `5` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Billing mode: PAY\_PER\_REQUEST (on-demand) or PROVISIONED. Provisioned requires read\_capacity / write\_capacity (and optional autoscaling). | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enable deletion protection on the table. | `bool` | `false` | no |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | Global Secondary Indexes. Each entry: { name, hash\_key, range\_key (optional), projection\_type (KEYS\_ONLY\|INCLUDE\|ALL), non\_key\_attributes (optional list, required when projection\_type = INCLUDE), read\_capacity (optional, PROVISIONED only), write\_capacity (optional, PROVISIONED only) }. | `any` | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Partition key attribute name. The matching attribute must be present in var.attributes. | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the customer-managed KMS key used for server-side encryption. When null, AWS-owned KMS is used. | `string` | `null` | no |
| <a name="input_local_secondary_indexes"></a> [local\_secondary\_indexes](#input\_local\_secondary\_indexes) | Local Secondary Indexes. Each entry: { name, range\_key, projection\_type (KEYS\_ONLY\|INCLUDE\|ALL), non\_key\_attributes (optional list, required when projection\_type = INCLUDE) }. LSIs require range\_key on the table. | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the DynamoDB table. Maximum 255 chars per AWS limit. | `string` | n/a | yes |
| <a name="input_point_in_time_recovery_enabled"></a> [point\_in\_time\_recovery\_enabled](#input\_point\_in\_time\_recovery\_enabled) | Enable point-in-time recovery (PITR). Recommended for production tables. | `bool` | `true` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | Optional sort key attribute name. When set, the matching attribute must be present in var.attributes. | `string` | `null` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | Provisioned read capacity units (only used when billing\_mode = PROVISIONED). | `number` | `0` | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Whether DynamoDB Streams are enabled. | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | Stream view type when stream\_enabled = true. One of NEW\_IMAGE, OLD\_IMAGE, NEW\_AND\_OLD\_IMAGES, KEYS\_ONLY. | `string` | `"NEW_AND_OLD_IMAGES"` | no |
| <a name="input_table_class"></a> [table\_class](#input\_table\_class) | Storage class: STANDARD or STANDARD\_INFREQUENT\_ACCESS. | `string` | `"STANDARD"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the table (and to autoscaling resources via inheritance from the table). | `map(string)` | `{}` | no |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | Attribute name to use for TTL. When null, TTL is disabled. The attribute must contain a Unix epoch (seconds) value. | `string` | `null` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | Provisioned write capacity units (only used when billing\_mode = PROVISIONED). | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscaling_read_target_arn"></a> [autoscaling\_read\_target\_arn](#output\_autoscaling\_read\_target\_arn) | Application Auto Scaling target ARN for table read capacity, or null when autoscaling is disabled. |
| <a name="output_autoscaling_write_target_arn"></a> [autoscaling\_write\_target\_arn](#output\_autoscaling\_write\_target\_arn) | Application Auto Scaling target ARN for table write capacity, or null when autoscaling is disabled. |
| <a name="output_stream_arn"></a> [stream\_arn](#output\_stream\_arn) | ARN of the DynamoDB Streams endpoint, or null when stream\_enabled = false. |
| <a name="output_stream_label"></a> [stream\_label](#output\_stream\_label) | Timestamp-based label of the DynamoDB Streams endpoint, or null when stream\_enabled = false. |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | ARN of the DynamoDB table. |
| <a name="output_table_id"></a> [table\_id](#output\_table\_id) | ID of the DynamoDB table (same as the table name). |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | Name of the DynamoDB table. |
