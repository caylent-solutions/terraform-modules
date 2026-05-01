## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_bus.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus) | resource |
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_identifier"></a> [kms\_key\_identifier](#input\_kms\_key\_identifier) | KMS key id, alias, or ARN used to encrypt event data on the bus. Null uses AWS-managed encryption. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the custom event bus. | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | Map of EventBridge rules to create. Key is the logical id; value is `{ name, description (optional), event_pattern (JSON-encoded string), state (optional, ENABLED/DISABLED) }`. | <pre>map(object({<br/>    name          = string<br/>    description   = optional(string)<br/>    event_pattern = string<br/>    state         = optional(string, "ENABLED")<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the bus and rules. | `map(string)` | `{}` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | Map of EventBridge targets to create. Key is the logical id; value is a typed object describing the target. `rule_key` MUST match a key in `var.rules` (validated cross-variable). `input`, `input_path`, and `input_transformer` are mutually exclusive at AWS-side; consumers should set only one. | <pre>map(object({<br/>    rule_key   = string<br/>    target_id  = string<br/>    arn        = string<br/>    role_arn   = optional(string)<br/>    input      = optional(string)<br/>    input_path = optional(string)<br/>    input_transformer = optional(object({<br/>      input_paths    = optional(map(string))<br/>      input_template = string<br/>    }))<br/>    dlq_arn = optional(string)<br/>    retry_policy = optional(object({<br/>      maximum_event_age_in_seconds = number<br/>      maximum_retry_attempts       = number<br/>    }))<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bus_arn"></a> [bus\_arn](#output\_bus\_arn) | ARN of the custom event bus. |
| <a name="output_bus_name"></a> [bus\_name](#output\_bus\_name) | Name of the custom event bus. |
| <a name="output_rule_arns"></a> [rule\_arns](#output\_rule\_arns) | Map of rule logical ids to rule ARNs. |
| <a name="output_rule_names"></a> [rule\_names](#output\_rule\_names) | Map of rule logical ids to rule names. |
| <a name="output_target_ids"></a> [target\_ids](#output\_target\_ids) | Map of target logical ids to target ids. |
