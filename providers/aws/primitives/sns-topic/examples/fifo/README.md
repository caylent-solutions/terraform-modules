# FIFO SNS Topic Example

This example demonstrates FIFO (First-In-First-Out) SNS topic configuration with content-based deduplication and tracing.

## Features

- FIFO topic with `.fifo` suffix
- Content-based deduplication enabled
- Active tracing for distributed tracing with AWS X-Ray
- KMS encryption using AWS managed key
- Standard tagging

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## FIFO Topic Features
- Messages are delivered in the exact order they are sent
- Exactly-once message delivery
- Message deduplication based on content
- Requires MessageGroupId when publishing

### Tracing
- Active tracing mode enables AWS X-Ray integration
- Provides end-to-end visibility of message flow
- Helps identify performance bottlenecks
