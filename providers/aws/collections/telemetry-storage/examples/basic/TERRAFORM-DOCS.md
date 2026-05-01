# Basic Example Documentation

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_telemetry_storage"></a> [telemetry\_storage](#module\_telemetry\_storage) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bus_name"></a> [bus\_name](#input\_bus\_name) | Base name for the EventBridge bus; the example appends a random suffix. | `string` | `"test-telemetry-bus"` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Base name for the SQS ingest queue; the example appends a random suffix. | `string` | `"test-telemetry-ingest"` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Base name for the DynamoDB table; the example appends a random suffix. | `string` | `"test-telemetry-events"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to module-managed resources. | `map(string)` | <pre>{<br/>  "Example": "basic",<br/>  "ManagedBy": "terraform",<br/>  "Module": "telemetry-storage"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bus_arn"></a> [bus\_arn](#output\_bus\_arn) | ARN of the EventBridge bus. |
| <a name="output_bus_name"></a> [bus\_name](#output\_bus\_name) | Name of the EventBridge bus. |
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | ARN of the dead-letter queue. |
| <a name="output_dlq_url"></a> [dlq\_url](#output\_dlq\_url) | URL of the dead-letter queue. |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | ARN of the primary ingest queue. |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | Name of the primary ingest queue. |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | URL of the primary ingest queue. |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | ARN of the DynamoDB table. |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | Name of the DynamoDB table. |
