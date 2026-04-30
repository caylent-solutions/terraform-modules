# Basic DynamoDB Table Example

This example demonstrates the minimal usage of the DynamoDB Table module with
a PAY_PER_REQUEST billing mode, point-in-time recovery enabled, and server-side
encryption using the AWS-managed key.

## Usage

```hcl
module "dynamodb_table" {
  source = "../../"

  name          = "my-table"
  hash_key      = "pk"
  hash_key_type = "S"

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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name for the DynamoDB table | `string` | n/a | yes |
| hash_key | Hash (partition) key attribute name | `string` | `"pk"` | no |
| hash_key_type | Hash key attribute type (S, N, B) | `string` | `"S"` | no |
| point_in_time_recovery_enabled | Enable PITR | `bool` | `true` | no |
| ttl_enabled | Enable TTL | `bool` | `false` | no |
| ttl_attribute_name | TTL attribute name | `string` | `"ttl"` | no |
| tags | Tags to apply | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| table_arn | ARN of the DynamoDB table |
| table_id | Name/ID of the DynamoDB table |
| table_name | Name of the DynamoDB table |
| table_hash_key | Hash key of the DynamoDB table |
| table_billing_mode | Billing mode of the DynamoDB table |
| table_stream_arn | ARN of the Table Stream |
| table_tags_all | All tags assigned to the table |

## Testing

This example is tested as part of the module test suite. To run tests for this example:

```bash
cd ../../
make test
```
