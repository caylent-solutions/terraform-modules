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
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_queue"></a> [queue](#module\_queue) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic.alerts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_dlq"></a> [create\_dlq](#input\_create\_dlq) | Whether to create the DLQ + redrive policy. | `bool` | `true` | no |
| <a name="input_create_dlq_depth_alarm"></a> [create\_dlq\_depth\_alarm](#input\_create\_dlq\_depth\_alarm) | Whether to create a CloudWatch alarm on DLQ depth (an SNS topic is provisioned alongside). | `bool` | `true` | no |
| <a name="input_dlq_depth_alarm_threshold"></a> [dlq\_depth\_alarm\_threshold](#input\_dlq\_depth\_alarm\_threshold) | Number of DLQ messages at which the alarm transitions to ALARM. | `number` | `1` | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Whether to create a FIFO queue. | `bool` | `false` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | Max receive count before redrive to DLQ. | `number` | `5` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | Message retention in seconds. | `number` | `345600` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Base name of the queue (a random suffix is appended for test isolation). | `string` | n/a | yes |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | Long-polling wait time in seconds. | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | Visibility timeout in seconds. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | ARN of the dead-letter queue, or null when create\_dlq is false. |
| <a name="output_dlq_depth_alarm_arn"></a> [dlq\_depth\_alarm\_arn](#output\_dlq\_depth\_alarm\_arn) | ARN of the CloudWatch alarm on DLQ depth, or null when create\_dlq\_depth\_alarm is false. |
| <a name="output_dlq_url"></a> [dlq\_url](#output\_dlq\_url) | URL of the dead-letter queue, or null when create\_dlq is false. |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | ARN of the primary SQS queue. |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | Name of the primary SQS queue. |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | URL of the primary SQS queue. |
<!-- END_TF_DOCS -->