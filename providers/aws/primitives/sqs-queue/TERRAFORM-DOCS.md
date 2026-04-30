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
| [aws_cloudwatch_metric_alarm.dlq_depth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | FIFO-only: enable content-based deduplication so the SHA-256 of the message body is used as the deduplication ID. | `bool` | `false` | no |
| <a name="input_create_dlq"></a> [create\_dlq](#input\_create\_dlq) | Whether to create a dead-letter queue and a redrive policy on the primary queue. | `bool` | `true` | no |
| <a name="input_create_dlq_depth_alarm"></a> [create\_dlq\_depth\_alarm](#input\_create\_dlq\_depth\_alarm) | Whether to create a CloudWatch alarm on the DLQ's ApproximateNumberOfMessagesVisible metric. Requires create\_dlq = true. | `bool` | `false` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | Time in seconds that the delivery of all messages in the queue is delayed (0-900). | `number` | `0` | no |
| <a name="input_dlq_depth_alarm_actions"></a> [dlq\_depth\_alarm\_actions](#input\_dlq\_depth\_alarm\_actions) | ARNs to notify when the DLQ depth alarm enters ALARM state (typically SNS topics). | `list(string)` | `[]` | no |
| <a name="input_dlq_depth_alarm_evaluation_periods"></a> [dlq\_depth\_alarm\_evaluation\_periods](#input\_dlq\_depth\_alarm\_evaluation\_periods) | Number of periods over which to evaluate the alarm metric. | `number` | `1` | no |
| <a name="input_dlq_depth_alarm_ok_actions"></a> [dlq\_depth\_alarm\_ok\_actions](#input\_dlq\_depth\_alarm\_ok\_actions) | ARNs to notify when the DLQ depth alarm returns to OK state. | `list(string)` | `[]` | no |
| <a name="input_dlq_depth_alarm_period_seconds"></a> [dlq\_depth\_alarm\_period\_seconds](#input\_dlq\_depth\_alarm\_period\_seconds) | Period in seconds over which the metric is aggregated. | `number` | `60` | no |
| <a name="input_dlq_depth_alarm_threshold"></a> [dlq\_depth\_alarm\_threshold](#input\_dlq\_depth\_alarm\_threshold) | Number of DLQ messages at which the alarm transitions to ALARM. | `number` | `1` | no |
| <a name="input_dlq_message_retention_seconds"></a> [dlq\_message\_retention\_seconds](#input\_dlq\_message\_retention\_seconds) | Number of seconds the DLQ retains a message (60-1209600). Defaults to 14 days for forensic investigation. Only used when create\_dlq = true. | `number` | `1209600` | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Whether to create a FIFO queue. FIFO queues append `.fifo` to the queue name and accept content\_based\_deduplication. | `bool` | `false` | no |
| <a name="input_kms_data_key_reuse_period_seconds"></a> [kms\_data\_key\_reuse\_period\_seconds](#input\_kms\_data\_key\_reuse\_period\_seconds) | Length of time in seconds for which Amazon SQS can reuse a data key (60-86400). Only applied when kms\_master\_key\_id is set. | `number` | `300` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | ARN or alias of the KMS CMK used for server-side encryption. When set, sqs\_managed\_sse\_enabled is forced off (mutually exclusive). | `string` | `null` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | Maximum message size in bytes (1024-262144). | `number` | `262144` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | Maximum number of times a message is received before being routed to the DLQ. Only used when create\_dlq = true. | `number` | `5` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | Number of seconds the queue retains a message (60-1209600). AWS default is 4 days; 14 days is the maximum. | `number` | `345600` | no |
| <a name="input_name"></a> [name](#input\_name) | Base name of the SQS queue. For FIFO queues, the module appends `.fifo`. The DLQ (when enabled) is named `<name>-dlq` (or `<name>-dlq.fifo`). | `string` | n/a | yes |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | Long-polling wait time in seconds (0-20). 0 disables long polling. | `number` | `0` | no |
| <a name="input_sqs_managed_sse_enabled"></a> [sqs\_managed\_sse\_enabled](#input\_sqs\_managed\_sse\_enabled) | Use AWS-managed SQS encryption (SSE-SQS). Only applied when kms\_master\_key\_id is null. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the queue, DLQ (when created), and CloudWatch alarm (when created). | `map(string)` | `{}` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | Visibility timeout in seconds (0-43200). Should match the maximum processing time of the consumer. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | ARN of the dead-letter queue, or null when create\_dlq is false. |
| <a name="output_dlq_depth_alarm_arn"></a> [dlq\_depth\_alarm\_arn](#output\_dlq\_depth\_alarm\_arn) | ARN of the CloudWatch alarm on the DLQ depth, or null when create\_dlq\_depth\_alarm is false. |
| <a name="output_dlq_name"></a> [dlq\_name](#output\_dlq\_name) | Name of the dead-letter queue, or null when create\_dlq is false. |
| <a name="output_dlq_url"></a> [dlq\_url](#output\_dlq\_url) | URL of the dead-letter queue, or null when create\_dlq is false. |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | ARN of the primary SQS queue. |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | URL of the primary SQS queue (the SQS API uses the URL as the resource id). |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | Name of the primary SQS queue, including the `.fifo` suffix when fifo\_queue is true. |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | URL of the primary SQS queue (alias for queue\_id). |
