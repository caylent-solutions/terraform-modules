# AWS SQS Queue Terraform Module

A Terraform primitive module for creating and managing AWS SQS queues with optional dead-letter queues (DLQ), redrive policies, KMS encryption, and CloudWatch alarms on DLQ depth.

## Overview

This module provides a production-ready SQS queue with:
- KMS encryption at rest (requires a caller-supplied customer-managed KMS key)
- Optional dead-letter queue with configurable redrive policy
- Optional CloudWatch metric alarm triggered when the DLQ message count exceeds a threshold
- Consistent resource tagging

## Key Features

- **Encryption at Rest**: All queues use KMS encryption with a caller-supplied customer-managed KMS key (required).
- **Dead-Letter Queue**: Optional DLQ with configurable `max_receive_count` redrive policy.
- **CloudWatch Alarm**: Optional alarm on DLQ approximate message count for operational visibility.
- **Configurable Retention**: Separate message retention settings for the main queue and the DLQ.
- **Comprehensive Tagging**: Automatic `ManagedBy` and `Module` tags merged with caller-supplied tags.

## Quick Start

### Basic Queue

```hcl
module "sqs_queue" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/sqs-queue?ref=providers/aws/primitives/sqs-queue/v0.1.0"

  name              = "my-telemetry-queue"
  kms_master_key_id = aws_kms_key.my_key.key_id

  tags = {
    Environment = "production"
    Project     = "telemetry"
  }
}
```

### Queue with DLQ and CloudWatch Alarm

```hcl
module "sqs_queue" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/sqs-queue?ref=providers/aws/primitives/sqs-queue/v0.1.0"

  name              = "my-telemetry-queue"
  kms_master_key_id = aws_kms_key.my_key.key_id
  enable_dlq        = true
  dlq_name          = "my-telemetry-queue-dlq"
  max_receive_count = 5

  enable_dlq_alarm    = true
  dlq_alarm_name      = "my-telemetry-queue-dlq-depth"
  dlq_alarm_threshold = 0
  dlq_alarm_actions   = ["arn:aws:sns:us-east-1:123456789012:ops-alerts"]

  tags = {
    Environment = "production"
    Project     = "telemetry"
  }
}
```

## Configuration Options

### Encryption

All queues require a caller-supplied customer-managed KMS key via the required `kms_master_key_id` variable. The AWS-managed SQS key (`alias/aws/sqs`) is not accepted; you must create a CMK and pass its ID or ARN:

```hcl
module "sqs_queue" {
  source = "..."

  name              = "my-queue"
  kms_master_key_id = aws_kms_key.my_key.key_id
}
```

### Dead-Letter Queue

Set `enable_dlq = true` and provide a `dlq_name` to activate the DLQ and the corresponding redrive policy on the main queue. The `max_receive_count` variable controls how many times a message is delivered before it is moved to the DLQ.

### CloudWatch Alarm

Set `enable_dlq_alarm = true` (requires `enable_dlq = true`) to create a `GreaterThanThreshold` CloudWatch alarm on the DLQ `ApproximateNumberOfMessagesVisible` metric. Supply SNS topic ARNs via `dlq_alarm_actions` for notifications.

## Examples

See the [examples](examples/) directory for complete working examples:

- [Basic](examples/basic/) - Queue with DLQ and CloudWatch alarm

## Technical Documentation

For detailed inputs, outputs, and resources, see [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Security Best Practices

1. **Encryption at Rest**: Always supply a customer-managed KMS key via `kms_master_key_id` for full key lifecycle control.
2. **Dead-Letter Queue**: Always enable a DLQ for production queues to prevent message loss.
3. **DLQ Alarm**: Set `enable_dlq_alarm = true` and wire `dlq_alarm_actions` to an SNS topic so failures surface promptly.
4. **Least Privilege**: Grant consumers only `sqs:ReceiveMessage`, `sqs:DeleteMessage`, and `sqs:GetQueueAttributes` on the queue ARN.

## Contributing

See [Contributing Guide](../../../../../../docs/CONTRIBUTING.md) for development and contribution guidelines.
