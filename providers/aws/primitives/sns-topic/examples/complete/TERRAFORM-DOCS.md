## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sns_topic"></a> [sns\_topic](#module\_sns\_topic) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name for the topic | `string` | `null` | no |
| <a name="input_enable_delivery_status_logging"></a> [enable\_delivery\_status\_logging](#input\_enable\_delivery\_status\_logging) | Enable delivery status logging for all subscription types | `bool` | `false` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | The ID or ARN of a customer-managed KMS key for SNS encryption. | `string` | `null` | no |
| <a name="input_lambda_failure_feedback_role_arn"></a> [lambda\_failure\_feedback\_role\_arn](#input\_lambda\_failure\_feedback\_role\_arn) | IAM role ARN for failed Lambda deliveries | `string` | `null` | no |
| <a name="input_lambda_success_feedback_role_arn"></a> [lambda\_success\_feedback\_role\_arn](#input\_lambda\_success\_feedback\_role\_arn) | IAM role ARN for successful Lambda deliveries | `string` | `null` | no |
| <a name="input_lambda_success_feedback_sample_rate"></a> [lambda\_success\_feedback\_sample\_rate](#input\_lambda\_success\_feedback\_sample\_rate) | Percentage of successful Lambda deliveries to log (0-100) | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the SNS topic. | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | The fully-formed AWS policy as JSON for the SNS topic | `string` | `null` | no |
| <a name="input_signature_version"></a> [signature\_version](#input\_signature\_version) | The signature version corresponds to the hashing algorithm used (1 or 2) | `string` | `"1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the topic. | `map(string)` | `{}` | no |
| <a name="input_tracing_config"></a> [tracing\_config](#input\_tracing\_config) | Tracing mode for the topic (PassThrough or Active) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | n/a |
| <a name="output_topic_name"></a> [topic\_name](#output\_topic\_name) | n/a |
