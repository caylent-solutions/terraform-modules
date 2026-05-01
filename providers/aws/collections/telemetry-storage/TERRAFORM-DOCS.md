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
| <a name="module_bus"></a> [bus](#module\_bus) | git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/eventbridge-bus | providers/aws/primitives/eventbridge-bus/v0.1.0 |
| <a name="module_queue"></a> [queue](#module\_queue) | git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/sqs-queue | providers/aws/primitives/sqs-queue/v0.1.0 |
| <a name="module_table"></a> [table](#module\_table) | git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/dynamodb-table | providers/aws/primitives/dynamodb-table/v0.1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bus_kms_key_identifier"></a> [bus\_kms\_key\_identifier](#input\_bus\_kms\_key\_identifier) | KMS CMK identifier used to encrypt events at rest. Null uses the AWS-managed key. | `string` | `null` | no |
| <a name="input_bus_name"></a> [bus\_name](#input\_bus\_name) | Name of the EventBridge bus. | `string` | n/a | yes |
| <a name="input_bus_rules"></a> [bus\_rules](#input\_bus\_rules) | Map of EventBridge rules. See the eventbridge-bus primitive for the object schema. | <pre>map(object({<br/>    name          = string<br/>    description   = optional(string)<br/>    event_pattern = string<br/>    state         = optional(string, "ENABLED")<br/>  }))</pre> | `{}` | no |
| <a name="input_bus_targets"></a> [bus\_targets](#input\_bus\_targets) | Map of EventBridge targets. Key is the logical id; value matches the eventbridge-bus primitive's typed object schema. `rule_key` must reference a key in `bus_rules`. `input`, `input_path`, and `input_transformer` are mutually exclusive. | <pre>map(object({<br/>    rule_key   = string<br/>    target_id  = string<br/>    arn        = string<br/>    role_arn   = optional(string)<br/>    input      = optional(string)<br/>    input_path = optional(string)<br/>    input_transformer = optional(object({<br/>      input_paths    = optional(map(string))<br/>      input_template = string<br/>    }))<br/>    dlq_arn = optional(string)<br/>    retry_policy = optional(object({<br/>      maximum_event_age_in_seconds = number<br/>      maximum_retry_attempts       = number<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_queue_create_dlq"></a> [queue\_create\_dlq](#input\_queue\_create\_dlq) | Whether to create the dead-letter queue and wire the primary queue's redrive policy at it. | `bool` | `true` | no |
| <a name="input_queue_create_dlq_depth_alarm"></a> [queue\_create\_dlq\_depth\_alarm](#input\_queue\_create\_dlq\_depth\_alarm) | Whether to create a CloudWatch alarm on the DLQ message-count metric. | `bool` | `false` | no |
| <a name="input_queue_delay_seconds"></a> [queue\_delay\_seconds](#input\_queue\_delay\_seconds) | Delivery delay applied to all messages enqueued (seconds). | `number` | `0` | no |
| <a name="input_queue_dlq_depth_alarm_actions"></a> [queue\_dlq\_depth\_alarm\_actions](#input\_queue\_dlq\_depth\_alarm\_actions) | List of ARNs invoked when the DLQ depth alarm enters ALARM state (typically SNS topic ARNs). | `list(string)` | `[]` | no |
| <a name="input_queue_dlq_depth_alarm_ok_actions"></a> [queue\_dlq\_depth\_alarm\_ok\_actions](#input\_queue\_dlq\_depth\_alarm\_ok\_actions) | List of ARNs invoked when the DLQ depth alarm returns to OK state. | `list(string)` | `[]` | no |
| <a name="input_queue_dlq_depth_alarm_threshold"></a> [queue\_dlq\_depth\_alarm\_threshold](#input\_queue\_dlq\_depth\_alarm\_threshold) | DLQ depth alarm threshold (number of messages). | `number` | `1` | no |
| <a name="input_queue_dlq_message_retention_seconds"></a> [queue\_dlq\_message\_retention\_seconds](#input\_queue\_dlq\_message\_retention\_seconds) | Retention period for messages in the dead-letter queue (seconds). | `number` | `1209600` | no |
| <a name="input_queue_kms_master_key_id"></a> [queue\_kms\_master\_key\_id](#input\_queue\_kms\_master\_key\_id) | KMS CMK ARN or alias for SSE-KMS encryption. When null, the primitive falls back to SQS-managed SSE. | `string` | `null` | no |
| <a name="input_queue_max_message_size"></a> [queue\_max\_message\_size](#input\_queue\_max\_message\_size) | Maximum message size in bytes (1024 to 262144). | `number` | `262144` | no |
| <a name="input_queue_max_receive_count"></a> [queue\_max\_receive\_count](#input\_queue\_max\_receive\_count) | maxReceiveCount on the redrive policy. After this many failed receives, messages move to the DLQ. | `number` | `5` | no |
| <a name="input_queue_message_retention_seconds"></a> [queue\_message\_retention\_seconds](#input\_queue\_message\_retention\_seconds) | Retention period for messages in the primary queue (seconds). | `number` | `345600` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Name of the primary ingest queue. | `string` | n/a | yes |
| <a name="input_queue_receive_wait_time_seconds"></a> [queue\_receive\_wait\_time\_seconds](#input\_queue\_receive\_wait\_time\_seconds) | Long-polling receive wait time (seconds). 0 disables long polling. | `number` | `20` | no |
| <a name="input_queue_sqs_managed_sse_enabled"></a> [queue\_sqs\_managed\_sse\_enabled](#input\_queue\_sqs\_managed\_sse\_enabled) | Enable SQS-managed server-side encryption when no KMS key is supplied. | `bool` | `true` | no |
| <a name="input_queue_visibility_timeout_seconds"></a> [queue\_visibility\_timeout\_seconds](#input\_queue\_visibility\_timeout\_seconds) | Visibility timeout in seconds for the primary queue. Should exceed the consumer Lambda's timeout. | `number` | `60` | no |
| <a name="input_table_attributes"></a> [table\_attributes](#input\_table\_attributes) | Attribute definitions for keys and indexes. Each entry is `{ name, type }` (type = S, N, or B). | <pre>list(object({<br/>    name = string<br/>    type = string<br/>  }))</pre> | n/a | yes |
| <a name="input_table_billing_mode"></a> [table\_billing\_mode](#input\_table\_billing\_mode) | Billing mode: PAY\_PER\_REQUEST or PROVISIONED. | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_table_class"></a> [table\_class](#input\_table\_class) | Table class: STANDARD or STANDARD\_INFREQUENT\_ACCESS. | `string` | `"STANDARD"` | no |
| <a name="input_table_deletion_protection_enabled"></a> [table\_deletion\_protection\_enabled](#input\_table\_deletion\_protection\_enabled) | Whether to enable deletion protection on the table. | `bool` | `false` | no |
| <a name="input_table_global_secondary_indexes"></a> [table\_global\_secondary\_indexes](#input\_table\_global\_secondary\_indexes) | Global Secondary Indexes (see dynamodb-table primitive for full schema). | `any` | `[]` | no |
| <a name="input_table_hash_key"></a> [table\_hash\_key](#input\_table\_hash\_key) | Hash key (partition key) attribute name. | `string` | n/a | yes |
| <a name="input_table_kms_key_arn"></a> [table\_kms\_key\_arn](#input\_table\_kms\_key\_arn) | Customer-managed KMS CMK ARN used for encryption at rest. Null falls back to AWS-owned key. | `string` | `null` | no |
| <a name="input_table_local_secondary_indexes"></a> [table\_local\_secondary\_indexes](#input\_table\_local\_secondary\_indexes) | Local Secondary Indexes (see dynamodb-table primitive for full schema). | `any` | `[]` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Name of the DynamoDB table. | `string` | n/a | yes |
| <a name="input_table_point_in_time_recovery_enabled"></a> [table\_point\_in\_time\_recovery\_enabled](#input\_table\_point\_in\_time\_recovery\_enabled) | Whether to enable point-in-time recovery (PITR). | `bool` | `true` | no |
| <a name="input_table_range_key"></a> [table\_range\_key](#input\_table\_range\_key) | Range key (sort key) attribute name. Null for tables without a sort key. | `string` | `null` | no |
| <a name="input_table_read_capacity"></a> [table\_read\_capacity](#input\_table\_read\_capacity) | Provisioned read capacity (only used when billing\_mode = PROVISIONED). | `number` | `0` | no |
| <a name="input_table_stream_enabled"></a> [table\_stream\_enabled](#input\_table\_stream\_enabled) | Whether to enable DynamoDB Streams on the table. | `bool` | `false` | no |
| <a name="input_table_stream_view_type"></a> [table\_stream\_view\_type](#input\_table\_stream\_view\_type) | DynamoDB Streams view type when stream\_enabled is true. One of NEW\_IMAGE, OLD\_IMAGE, NEW\_AND\_OLD\_IMAGES, KEYS\_ONLY. | `string` | `"NEW_AND_OLD_IMAGES"` | no |
| <a name="input_table_ttl_attribute_name"></a> [table\_ttl\_attribute\_name](#input\_table\_ttl\_attribute\_name) | Name of the attribute used for DynamoDB TTL. Null disables TTL. | `string` | `null` | no |
| <a name="input_table_write_capacity"></a> [table\_write\_capacity](#input\_table\_write\_capacity) | Provisioned write capacity (only used when billing\_mode = PROVISIONED). | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all module-managed resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bus_arn"></a> [bus\_arn](#output\_bus\_arn) | ARN of the EventBridge bus. |
| <a name="output_bus_name"></a> [bus\_name](#output\_bus\_name) | Name of the EventBridge bus. |
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | ARN of the dead-letter queue, or null when queue\_create\_dlq is false. |
| <a name="output_dlq_url"></a> [dlq\_url](#output\_dlq\_url) | URL of the dead-letter queue, or null when queue\_create\_dlq is false. |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | ARN of the primary ingest queue. |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | Name of the primary ingest queue. |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | URL of the primary ingest queue. |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | ARN of the DynamoDB table. |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | Name of the DynamoDB table. |
| <a name="output_table_stream_arn"></a> [table\_stream\_arn](#output\_table\_stream\_arn) | ARN of the DynamoDB stream, or null when table\_stream\_enabled is false. |
