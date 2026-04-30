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
| [aws_appautoscaling_policy.read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_appautoscaling_target.write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input__autoscaling_policy_type"></a> [\_autoscaling\_policy\_type](#input\_\_autoscaling\_policy\_type) | Auto-Scaling policy type for DynamoDB target tracking. Do not override. | `string` | `"TargetTrackingScaling"` | no |
| <a name="input__autoscaling_read_predefined_metric_type"></a> [\_autoscaling\_read\_predefined\_metric\_type](#input\_\_autoscaling\_read\_predefined\_metric\_type) | Predefined metric type for DynamoDB read capacity utilization. Do not override. | `string` | `"DynamoDBReadCapacityUtilization"` | no |
| <a name="input__autoscaling_read_scalable_dimension"></a> [\_autoscaling\_read\_scalable\_dimension](#input\_\_autoscaling\_read\_scalable\_dimension) | Application Auto-Scaling scalable dimension for DynamoDB read capacity. Do not override. | `string` | `"dynamodb:table:ReadCapacityUnits"` | no |
| <a name="input__autoscaling_resource_type"></a> [\_autoscaling\_resource\_type](#input\_\_autoscaling\_resource\_type) | DynamoDB Application Auto-Scaling resource type prefix. Do not override. | `string` | `"table"` | no |
| <a name="input__autoscaling_service_namespace"></a> [\_autoscaling\_service\_namespace](#input\_\_autoscaling\_service\_namespace) | AWS Application Auto-Scaling service namespace for DynamoDB. Do not override. | `string` | `"dynamodb"` | no |
| <a name="input__autoscaling_write_predefined_metric_type"></a> [\_autoscaling\_write\_predefined\_metric\_type](#input\_\_autoscaling\_write\_predefined\_metric\_type) | Predefined metric type for DynamoDB write capacity utilization. Do not override. | `string` | `"DynamoDBWriteCapacityUtilization"` | no |
| <a name="input__autoscaling_write_scalable_dimension"></a> [\_autoscaling\_write\_scalable\_dimension](#input\_\_autoscaling\_write\_scalable\_dimension) | Application Auto-Scaling scalable dimension for DynamoDB write capacity. Do not override. | `string` | `"dynamodb:table:WriteCapacityUnits"` | no |
| <a name="input__sse_enabled"></a> [\_sse\_enabled](#input\_\_sse\_enabled) | Server-side encryption must always be enabled. Do not override. | `bool` | `true` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | (Optional) Whether to enable auto-scaling for read/write capacity. Only applies when billing\_mode is PROVISIONED. | `bool` | `false` | no |
| <a name="input_autoscaling_read_max_capacity"></a> [autoscaling\_read\_max\_capacity](#input\_autoscaling\_read\_max\_capacity) | (Optional) Maximum read capacity for auto-scaling. | `number` | `10` | no |
| <a name="input_autoscaling_read_min_capacity"></a> [autoscaling\_read\_min\_capacity](#input\_autoscaling\_read\_min\_capacity) | (Optional) Minimum read capacity for auto-scaling. | `number` | `1` | no |
| <a name="input_autoscaling_read_target_value"></a> [autoscaling\_read\_target\_value](#input\_autoscaling\_read\_target\_value) | (Optional) Target utilization percentage for read auto-scaling. | `number` | `70` | no |
| <a name="input_autoscaling_write_max_capacity"></a> [autoscaling\_write\_max\_capacity](#input\_autoscaling\_write\_max\_capacity) | (Optional) Maximum write capacity for auto-scaling. | `number` | `10` | no |
| <a name="input_autoscaling_write_min_capacity"></a> [autoscaling\_write\_min\_capacity](#input\_autoscaling\_write\_min\_capacity) | (Optional) Minimum write capacity for auto-scaling. | `number` | `1` | no |
| <a name="input_autoscaling_write_target_value"></a> [autoscaling\_write\_target\_value](#input\_autoscaling\_write\_target\_value) | (Optional) Target utilization percentage for write auto-scaling. | `number` | `70` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | (Optional) Controls how you are charged for read and write throughput. Valid values: PAY\_PER\_REQUEST, PROVISIONED. | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | (Optional) Whether to enable deletion protection on the table. | `bool` | `false` | no |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | (Optional) List of Global Secondary Index definitions. | <pre>list(object({<br/>    name               = string<br/>    hash_key           = string<br/>    hash_key_type      = string<br/>    range_key          = optional(string)<br/>    range_key_type     = optional(string)<br/>    projection_type    = string<br/>    non_key_attributes = optional(list(string))<br/>    read_capacity      = optional(number)<br/>    write_capacity     = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | (Required) Attribute to use as the hash (partition) key. | `string` | n/a | yes |
| <a name="input_hash_key_type"></a> [hash\_key\_type](#input\_hash\_key\_type) | (Required) Attribute type for the hash key. Valid values: S (string), N (number), B (binary). | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | (Optional) ARN of the AWS KMS CMK to use for server-side encryption. When null, AWS-managed key is used. | `string` | `null` | no |
| <a name="input_local_secondary_indexes"></a> [local\_secondary\_indexes](#input\_local\_secondary\_indexes) | (Optional) List of Local Secondary Index definitions. A range\_key on the table is required when LSIs are defined. | <pre>list(object({<br/>    name               = string<br/>    range_key          = string<br/>    range_key_type     = string<br/>    projection_type    = string<br/>    non_key_attributes = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_managed_by_tag"></a> [managed\_by\_tag](#input\_managed\_by\_tag) | (Optional) Value for the ManagedBy tag. | `string` | `"terraform"` | no |
| <a name="input_module_tag"></a> [module\_tag](#input\_module\_tag) | (Optional) Value for the Module tag. | `string` | `"dynamodb-table"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the DynamoDB table. | `string` | n/a | yes |
| <a name="input_point_in_time_recovery_enabled"></a> [point\_in\_time\_recovery\_enabled](#input\_point\_in\_time\_recovery\_enabled) | (Optional) Whether to enable point-in-time recovery for the table. | `bool` | `true` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | (Optional) Attribute to use as the range (sort) key. Null disables range key. | `string` | `null` | no |
| <a name="input_range_key_type"></a> [range\_key\_type](#input\_range\_key\_type) | (Optional) Attribute type for the range key. Required when range\_key is set. Valid values: S, N, B. | `string` | `null` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | (Optional) Number of read units for the table. Required when billing\_mode is PROVISIONED. | `number` | `null` | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | (Optional) Whether to enable DynamoDB Streams for this table. | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | (Optional) When stream is enabled, the information written to the stream. Required when stream\_enabled is true. Valid values: KEYS\_ONLY, NEW\_IMAGE, OLD\_IMAGE, NEW\_AND\_OLD\_IMAGES. | `string` | `null` | no |
| <a name="input_table_class"></a> [table\_class](#input\_table\_class) | (Optional) Storage class of the table. Valid values: STANDARD, STANDARD\_INFREQUENT\_ACCESS. | `string` | `"STANDARD"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to the table. | `map(string)` | `{}` | no |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | (Optional) Name of the TTL attribute. Required when ttl\_enabled is true. | `string` | `"ttl"` | no |
| <a name="input_ttl_enabled"></a> [ttl\_enabled](#input\_ttl\_enabled) | (Optional) Whether to enable time-to-live on the table. | `bool` | `false` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | (Optional) Number of write units for the table. Required when billing\_mode is PROVISIONED. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscaling_read_target_arn"></a> [autoscaling\_read\_target\_arn](#output\_autoscaling\_read\_target\_arn) | The ARN of the read auto-scaling target. Empty when autoscaling is disabled. |
| <a name="output_autoscaling_write_target_arn"></a> [autoscaling\_write\_target\_arn](#output\_autoscaling\_write\_target\_arn) | The ARN of the write auto-scaling target. Empty when autoscaling is disabled. |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | The ARN of the DynamoDB table. |
| <a name="output_table_billing_mode"></a> [table\_billing\_mode](#output\_table\_billing\_mode) | The billing mode of the DynamoDB table. |
| <a name="output_table_hash_key"></a> [table\_hash\_key](#output\_table\_hash\_key) | The hash key of the DynamoDB table. |
| <a name="output_table_id"></a> [table\_id](#output\_table\_id) | The name of the DynamoDB table. |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | The name of the DynamoDB table. |
| <a name="output_table_range_key"></a> [table\_range\_key](#output\_table\_range\_key) | The range key of the DynamoDB table. |
| <a name="output_table_stream_arn"></a> [table\_stream\_arn](#output\_table\_stream\_arn) | The ARN of the Table Stream. Only available when stream\_enabled is true. |
| <a name="output_table_stream_label"></a> [table\_stream\_label](#output\_table\_stream\_label) | A timestamp, in ISO 8601 format, for the Table Stream. Only available when stream\_enabled is true. |
| <a name="output_table_tags_all"></a> [table\_tags\_all](#output\_table\_tags\_all) | A map of tags assigned to the table, including those inherited from the provider default\_tags configuration block. |
