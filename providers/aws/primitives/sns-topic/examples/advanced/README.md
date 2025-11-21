# FIFO SNS Topic Example

This example demonstrates how to create a FIFO (First-In-First-Out) SNS topic with content-based deduplication enabled.

## Features

- FIFO topic with `.fifo` suffix
- Content-based deduplication enabled
- KMS encryption using AWS managed key
- Standard tagging

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## FIFO Topic Characteristics

- Messages are delivered in the exact order they are sent
- Exactly-once message delivery
- Message deduplication based on content
- Requires MessageGroupId when publishing
