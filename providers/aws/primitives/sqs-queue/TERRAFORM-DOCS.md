## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.dlq_depth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | (Optional) The time in seconds that the delivery of all messages in the queue will be delayed. Defaults to 0. | `number` | `0` | no |
| <a name="input_dlq_alarm_actions"></a> [dlq\_alarm\_actions](#input\_dlq\_alarm\_actions) | (Optional) The list of ARNs to notify when the DLQ depth alarm transitions to ALARM state. | `list(string)` | `[]` | no |
| <a name="input_dlq_alarm_comparison_operator"></a> [dlq\_alarm\_comparison\_operator](#input\_dlq\_alarm\_comparison\_operator) | (Optional) The comparison operator for the DLQ depth alarm. Defaults to GreaterThanThreshold. | `string` | `"GreaterThanThreshold"` | no |
| <a name="input_dlq_alarm_description"></a> [dlq\_alarm\_description](#input\_dlq\_alarm\_description) | (Optional) Description for the DLQ depth CloudWatch alarm. | `string` | `"Dead-letter queue depth alarm"` | no |
| <a name="input_dlq_alarm_evaluation_periods"></a> [dlq\_alarm\_evaluation\_periods](#input\_dlq\_alarm\_evaluation\_periods) | (Optional) The number of periods to evaluate for the DLQ depth alarm. Defaults to 1. | `number` | `1` | no |
| <a name="input_dlq_alarm_metric_name"></a> [dlq\_alarm\_metric\_name](#input\_dlq\_alarm\_metric\_name) | (Optional) The name of the CloudWatch metric for the DLQ depth alarm. Defaults to ApproximateNumberOfMessagesVisible. | `string` | `"ApproximateNumberOfMessagesVisible"` | no |
| <a name="input_dlq_alarm_name"></a> [dlq\_alarm\_name](#input\_dlq\_alarm\_name) | (Optional) The name of the CloudWatch alarm for DLQ depth. Required when enable\_dlq\_alarm is true. | `string` | `null` | no |
| <a name="input_dlq_alarm_namespace"></a> [dlq\_alarm\_namespace](#input\_dlq\_alarm\_namespace) | (Optional) The CloudWatch namespace for the DLQ depth alarm metric. Defaults to AWS/SQS. | `string` | `"AWS/SQS"` | no |
| <a name="input_dlq_alarm_ok_actions"></a> [dlq\_alarm\_ok\_actions](#input\_dlq\_alarm\_ok\_actions) | (Optional) The list of ARNs to notify when the DLQ depth alarm transitions to OK state. | `list(string)` | `[]` | no |
| <a name="input_dlq_alarm_period_seconds"></a> [dlq\_alarm\_period\_seconds](#input\_dlq\_alarm\_period\_seconds) | (Optional) The period in seconds for the DLQ depth alarm metric. Defaults to 60. | `number` | `60` | no |
| <a name="input_dlq_alarm_statistic"></a> [dlq\_alarm\_statistic](#input\_dlq\_alarm\_statistic) | (Optional) The statistic to apply to the DLQ depth alarm metric. Defaults to Sum. | `string` | `"Sum"` | no |
| <a name="input_dlq_alarm_threshold"></a> [dlq\_alarm\_threshold](#input\_dlq\_alarm\_threshold) | (Optional) The threshold for the DLQ depth alarm. Defaults to 0 (alarm on any message). | `number` | `0` | no |
| <a name="input_dlq_message_retention_seconds"></a> [dlq\_message\_retention\_seconds](#input\_dlq\_message\_retention\_seconds) | (Optional) The number of seconds the DLQ retains a message. Defaults to 1209600 (14 days). | `number` | `1209600` | no |
| <a name="input_dlq_name"></a> [dlq\_name](#input\_dlq\_name) | (Optional) The name of the dead-letter queue. Required when enable\_dlq is true. | `string` | `null` | no |
| <a name="input_enable_dlq"></a> [enable\_dlq](#input\_enable\_dlq) | (Optional) Whether to create a dead-letter queue for the main queue. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_dlq_alarm"></a> [enable\_dlq\_alarm](#input\_enable\_dlq\_alarm) | (Optional) Whether to create a CloudWatch alarm for DLQ depth. Requires enable\_dlq to be true. Defaults to false. | `bool` | `false` | no |
| <a name="input_kms_data_key_reuse_period_seconds"></a> [kms\_data\_key\_reuse\_period\_seconds](#input\_kms\_data\_key\_reuse\_period\_seconds) | (Optional) The length of time, in seconds, for which Amazon SQS can reuse a data key. Defaults to 300. | `number` | `300` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | (Required) The ID or ARN of a customer-managed KMS key for SQS queue encryption. Must be a customer-managed key, not the AWS-managed SQS key. | `string` | n/a | yes |
| <a name="input_managed_by_tag"></a> [managed\_by\_tag](#input\_managed\_by\_tag) | (Optional) Value for the ManagedBy tag. | `string` | `"terraform"` | no |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | (Optional) The limit of how many bytes a message can contain. Defaults to 262144 (256 KiB). | `number` | `262144` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | (Optional) The number of times a message is received before being moved to the DLQ. Defaults to 5. | `number` | `5` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | (Optional) The number of seconds Amazon SQS retains a message. Defaults to 345600 (4 days). | `number` | `345600` | no |
| <a name="input_module_tag"></a> [module\_tag](#input\_module\_tag) | (Optional) Value for the Module tag. | `string` | `"sqs-queue"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the SQS queue. | `string` | n/a | yes |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | (Optional) The time for which a ReceiveMessage call will wait for a message to arrive. Defaults to 0 (short polling). | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to all resources. | `map(string)` | `{}` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | (Optional) The visibility timeout for the queue, in seconds. Defaults to 30. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq_alarm_arn"></a> [dlq\_alarm\_arn](#output\_dlq\_alarm\_arn) | The ARN of the DLQ depth CloudWatch alarm. Null if enable\_dlq\_alarm is false. |
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | The ARN of the dead-letter queue. Null if enable\_dlq is false. |
| <a name="output_dlq_id"></a> [dlq\_id](#output\_dlq\_id) | The URL of the dead-letter queue. Null if enable\_dlq is false. |
| <a name="output_dlq_name"></a> [dlq\_name](#output\_dlq\_name) | The name of the dead-letter queue. Null if enable\_dlq is false. |
| <a name="output_dlq_url"></a> [dlq\_url](#output\_dlq\_url) | The URL of the dead-letter queue. Null if enable\_dlq is false. |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | The ARN of the SQS queue. |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | The URL of the SQS queue. |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | The name of the SQS queue. |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | The URL of the SQS queue (same as queue\_id). |
