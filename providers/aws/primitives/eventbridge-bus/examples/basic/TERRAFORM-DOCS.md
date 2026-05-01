# Basic Example Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bus"></a> [bus](#module\_bus) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_sqs_queue.dlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bus_name"></a> [bus\_name](#input\_bus\_name) | Base bus name (a random suffix is appended). | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bus_arn"></a> [bus\_arn](#output\_bus\_arn) | ARN of the custom event bus. |
| <a name="output_bus_name"></a> [bus\_name](#output\_bus\_name) | Name of the bus. |
| <a name="output_rule_arns"></a> [rule\_arns](#output\_rule\_arns) | Rule ARNs by logical id. |
| <a name="output_target_queue_arn"></a> [target\_queue\_arn](#output\_target\_queue\_arn) | ARN of the SQS target queue. |
<!-- END_TF_DOCS -->