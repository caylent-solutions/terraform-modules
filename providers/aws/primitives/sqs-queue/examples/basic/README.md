# sqs-queue / basic example

Provisions a primary SQS queue, a DLQ wired via redrive policy, and a
CloudWatch alarm on DLQ depth notifying an SNS topic.

## What it creates

- `aws_sns_topic.alerts` (when `create_dlq_depth_alarm = true`) for
  alarm notifications.
- `module.queue` -- the `sqs-queue` primitive, configured with:
  - `name`, `fifo_queue`, `visibility_timeout_seconds`,
    `message_retention_seconds`, `receive_wait_time_seconds`
  - DLQ enabled (`create_dlq = true`) with the configured
    `max_receive_count`
  - DLQ depth alarm enabled with the configured threshold and SNS
    topic ARNs for ALARM/OK transitions

## Apply

```bash
cd providers/aws/primitives/sqs-queue/examples/basic
terraform init
terraform apply -auto-approve
```

## Outputs

- `queue_arn`, `queue_url`, `queue_name`
- `dlq_arn`, `dlq_url`
- `dlq_depth_alarm_arn`

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md) for the auto-generated
inputs/outputs reference.
