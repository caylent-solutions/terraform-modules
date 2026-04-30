## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | (Optional) Description of the secret. | `string` | `null` | no |
| <a name="input_enable_rotation"></a> [enable\_rotation](#input\_enable\_rotation) | (Optional) Whether to enable automatic rotation for this secret. Requires rotation\_lambda\_arn when true. Defaults to false. | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | (Required) ARN or ID of the AWS KMS key used to encrypt the secret. All secrets must be encrypted at rest. | `string` | n/a | yes |
| <a name="input_managed_by_tag"></a> [managed\_by\_tag](#input\_managed\_by\_tag) | (Optional) Value for the ManagedBy tag. | `string` | `"terraform"` | no |
| <a name="input_module_tag"></a> [module\_tag](#input\_module\_tag) | (Optional) Value for the Module tag. | `string` | `"secrets-manager-secret"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Friendly name of the new secret. Must be unique within your AWS account and region. | `string` | n/a | yes |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | (Optional) Number of days AWS Secrets Manager waits before it can delete the secret. Must be 0 (force delete) or between 7 and 30. Defaults to 30. | `number` | `30` | no |
| <a name="input_rotation_days"></a> [rotation\_days](#input\_rotation\_days) | (Optional) Number of days between automatic scheduled rotations. Must be between 1 and 365. Defaults to 90 per security policy. | `number` | `90` | no |
| <a name="input_rotation_lambda_arn"></a> [rotation\_lambda\_arn](#input\_rotation\_lambda\_arn) | (Optional) ARN of the Lambda function that performs rotation. Required when enable\_rotation is true. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to the secret. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The ARN or ID of the KMS key used to encrypt the secret. |
| <a name="output_rotation_enabled"></a> [rotation\_enabled](#output\_rotation\_enabled) | Whether automatic rotation is enabled for this secret. |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | The ARN of the Secrets Manager secret. |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | The ID of the Secrets Manager secret (same as the ARN). |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | The friendly name of the Secrets Manager secret. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
