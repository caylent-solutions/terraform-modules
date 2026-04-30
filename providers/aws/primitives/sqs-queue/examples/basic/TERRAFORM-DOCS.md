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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sqs_queue"></a> [sqs\_queue](#module\_sqs\_queue) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dlq_alarm_name"></a> [dlq\_alarm\_name](#input\_dlq\_alarm\_name) | The name of the CloudWatch alarm for DLQ depth. | `string` | `null` | no |
| <a name="input_dlq_alarm_threshold"></a> [dlq\_alarm\_threshold](#input\_dlq\_alarm\_threshold) | The threshold for the DLQ depth alarm. | `number` | `0` | no |
| <a name="input_dlq_name"></a> [dlq\_name](#input\_dlq\_name) | The name of the dead-letter queue. | `string` | `null` | no |
| <a name="input_enable_dlq"></a> [enable\_dlq](#input\_enable\_dlq) | Whether to create a dead-letter queue. | `bool` | `false` | no |
| <a name="input_enable_dlq_alarm"></a> [enable\_dlq\_alarm](#input\_enable\_dlq\_alarm) | Whether to create a CloudWatch alarm for DLQ depth. | `bool` | `false` | no |
| <a name="input_kms_key_deletion_window_in_days"></a> [kms\_key\_deletion\_window\_in\_days](#input\_kms\_key\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction. | `number` | `7` | no |
| <a name="input_kms_key_description"></a> [kms\_key\_description](#input\_kms\_key\_description) | Description for the KMS key used to encrypt the SQS queue. | `string` | `"Customer-managed KMS key for SQS queue encryption"` | no |
| <a name="input_kms_key_enable_rotation"></a> [kms\_key\_enable\_rotation](#input\_kms\_key\_enable\_rotation) | Whether to enable automatic key rotation for the KMS key. | `bool` | `true` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | Number of times a message is received before being moved to the DLQ. | `number` | `5` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message. | `number` | `345600` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the SQS queue. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout for the queue in seconds. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq_alarm_arn"></a> [dlq\_alarm\_arn](#output\_dlq\_alarm\_arn) | The ARN of the DLQ depth CloudWatch alarm. |
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | The ARN of the dead-letter queue. |
| <a name="output_dlq_id"></a> [dlq\_id](#output\_dlq\_id) | The URL of the dead-letter queue. |
| <a name="output_dlq_name"></a> [dlq\_name](#output\_dlq\_name) | The name of the dead-letter queue. |
| <a name="output_dlq_url"></a> [dlq\_url](#output\_dlq\_url) | The URL of the dead-letter queue. |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key used for SQS encryption. |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | The ARN of the SQS queue. |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | The URL of the SQS queue. |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | The name of the SQS queue. |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | The URL of the SQS queue. |
