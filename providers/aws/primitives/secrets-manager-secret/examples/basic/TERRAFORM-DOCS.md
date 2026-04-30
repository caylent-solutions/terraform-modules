# Basic Example Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_secret"></a> [secret](#module\_secret) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the secret. | `string` | `"Basic example secret for secrets-manager-secret module"` | no |
| <a name="input_enable_rotation"></a> [enable\_rotation](#input\_enable\_rotation) | Whether to enable automatic rotation. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Friendly name of the Secrets Manager secret. | `string` | `"telemetry-basic-secret"` | no |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | Number of days before the secret can be permanently deleted. | `number` | `7` | no |
| <a name="input_rotation_days"></a> [rotation\_days](#input\_rotation\_days) | Number of days between automatic rotations. | `number` | `90` | no |
| <a name="input_rotation_lambda_arn"></a> [rotation\_lambda\_arn](#input\_rotation\_lambda\_arn) | ARN of the Lambda function that rotates the secret. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | <pre>{<br/>  "Environment": "test",<br/>  "Owner": "terraform",<br/>  "Purpose": "secrets-manager-secret-module-testing"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The ARN of the KMS key used to encrypt the secret. |
| <a name="output_rotation_enabled"></a> [rotation\_enabled](#output\_rotation\_enabled) | Whether automatic rotation is enabled for this secret. |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | The ARN of the Secrets Manager secret. |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | The ID of the Secrets Manager secret. |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | The friendly name of the Secrets Manager secret. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of all tags assigned to the secret. |
<!-- END_TF_DOCS -->