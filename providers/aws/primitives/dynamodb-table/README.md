# AWS DynamoDB Table Terraform Module

A Terraform primitive module for creating and managing AWS DynamoDB tables with
configurable hash/range keys, Global Secondary Indexes (GSIs), Local Secondary
Indexes (LSIs), server-side encryption with KMS CMK, point-in-time recovery,
TTL, DynamoDB Streams, and application auto-scaling.

## Overview

This module provisions a single DynamoDB table along with optional application
auto-scaling targets and policies. All storage-at-rest encryption is enabled by
default; a KMS CMK ARN may be provided for customer-managed key encryption.

## Key Features

- **PAY_PER_REQUEST or PROVISIONED billing**: Configurable billing mode with optional auto-scaling for PROVISIONED mode
- **Flexible key schema**: Configurable hash (partition) key and optional range (sort) key
- **Global Secondary Indexes**: Up to 20 GSIs with configurable keys and projections
- **Local Secondary Indexes**: Up to 5 LSIs sharing the table partition key
- **Encryption at rest**: Server-side encryption always enabled; KMS CMK supported
- **Point-in-time recovery**: PITR enabled by default for data durability
- **TTL**: Optional time-to-live attribute for automatic item expiration
- **DynamoDB Streams**: Optional stream configuration for change-data-capture
- **Application Auto-Scaling**: Optional read/write auto-scaling for PROVISIONED mode
- **Deletion protection**: Optional protection against accidental table deletion

## Quick Start

```hcl
module "dynamodb_table" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/dynamodb-table?ref=providers/aws/primitives/dynamodb-table/v0.1.0"

  name          = "telemetry-events"
  hash_key      = "pk"
  hash_key_type = "S"

  tags = {
    Environment = "production"
    Project     = "telemetry-platform"
  }
}
```

### Table with KMS CMK Encryption and PITR

```hcl
module "dynamodb_table" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/dynamodb-table?ref=providers/aws/primitives/dynamodb-table/v0.1.0"

  name                           = "telemetry-events"
  hash_key                       = "pk"
  hash_key_type                  = "S"
  range_key                      = "sk"
  range_key_type                 = "S"
  kms_key_arn                    = "arn:aws:kms:us-east-1:123456789012:key/mrk-abc123"
  point_in_time_recovery_enabled = true

  tags = {
    Environment = "production"
  }
}
```

### Table with GSI and Streams

```hcl
module "dynamodb_table" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/dynamodb-table?ref=providers/aws/primitives/dynamodb-table/v0.1.0"

  name          = "telemetry-events"
  hash_key      = "pk"
  hash_key_type = "S"
  range_key     = "sk"
  range_key_type = "S"

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  global_secondary_indexes = [
    {
      name            = "gsi-by-account"
      hash_key        = "account_id"
      hash_key_type   = "S"
      projection_type = "ALL"
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.12.1 |
| aws | ~> 6.0.0 |

## Inputs

See `TERRAFORM-DOCS.md` for the full auto-generated input/output reference.

## Outputs

| Name | Description |
|------|-------------|
| table_arn | The ARN of the DynamoDB table |
| table_id | The name of the DynamoDB table |
| table_name | The name of the DynamoDB table |
| table_hash_key | The hash key of the DynamoDB table |
| table_range_key | The range key of the DynamoDB table |
| table_stream_arn | The ARN of the Table Stream (when stream_enabled is true) |
| table_stream_label | A timestamp for the Table Stream (when stream_enabled is true) |
| table_billing_mode | The billing mode of the DynamoDB table |
| table_tags_all | A map of all tags assigned to the table |
| autoscaling_read_target_arn | The ARN of the read auto-scaling target |
| autoscaling_write_target_arn | The ARN of the write auto-scaling target |

## Examples

- [Basic](./examples/basic/) -- Minimal PAY_PER_REQUEST table with KMS CMK encryption

## Testing

Tests use the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

```bash
make cpm-configure
make install
make test
```

See [tests/README.md](./tests/README.md) for full test documentation.
