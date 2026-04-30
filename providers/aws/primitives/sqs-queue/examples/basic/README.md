# Basic SQS Queue Example

This example demonstrates a basic usage of the `sqs-queue` primitive module with an optional dead-letter queue and CloudWatch alarm.

## Overview

This example creates:
- An SQS queue with KMS encryption at rest
- An optional dead-letter queue (DLQ) with a redrive policy
- An optional CloudWatch alarm that triggers when DLQ depth exceeds a threshold

## Usage

```hcl
resource "aws_kms_key" "sqs" {
  description             = "KMS key for SQS queue encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

module "sqs_queue" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/sqs-queue?ref=providers/aws/primitives/sqs-queue/v0.1.0"

  name              = "my-telemetry-queue"
  kms_master_key_id = aws_kms_key.sqs.key_id
  enable_dlq        = true
  dlq_name          = "my-telemetry-queue-dlq"
  max_receive_count = 5
  enable_dlq_alarm  = true
  dlq_alarm_name    = "my-telemetry-queue-dlq-depth"

  tags = {
    Environment = "production"
    Project     = "telemetry"
  }
}
```

## Requirements

- Terraform >= 1.12.1
- AWS provider ~> 6.0.0
- AWS credentials configured

## Inputs

Refer to [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for all inputs and outputs.

## Testing

This example is tested as part of the module's test suite. To run tests for this example:

```bash
cd ../../
make test
```
