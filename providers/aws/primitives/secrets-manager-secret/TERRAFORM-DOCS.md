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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_policy) | resource |
| [aws_secretsmanager_secret_rotation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the secret. | `string` | `null` | no |
| <a name="input_initial_secret_string"></a> [initial\_secret\_string](#input\_initial\_secret\_string) | Initial secret value as a plain string. Null skips creating the initial version (consumers populate via SDK or another resource). Treat as sensitive when set. | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key id, alias name, alias ARN, or key ARN used to encrypt the secret. When null, the AWS-managed key `aws/secretsmanager` is used. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the secret. The full ARN appends a random 6-character suffix that AWS reserves for each secret. | `string` | n/a | yes |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | Number of days that AWS Secrets Manager waits before deleting a secret on destroy. 0 forces immediate deletion (no recovery); 7-30 enables a recovery window. | `number` | `30` | no |
| <a name="input_replica_regions"></a> [replica\_regions](#input\_replica\_regions) | List of replica region configurations: `[{ region, kms_key_id (optional) }, ...]`. Empty list disables replication. | <pre>list(object({<br/>    region     = string<br/>    kms_key_id = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_resource_policy_json"></a> [resource\_policy\_json](#input\_resource\_policy\_json) | Optional resource-based policy attached to the secret. Provide a JSON-encoded string. Null skips attaching a resource policy. | `string` | `null` | no |
| <a name="input_rotation_automatically_after_days"></a> [rotation\_automatically\_after\_days](#input\_rotation\_automatically\_after\_days) | Rotation cadence in days. Per spec/security.md the default is 90 days. | `number` | `90` | no |
| <a name="input_rotation_lambda_arn"></a> [rotation\_lambda\_arn](#input\_rotation\_lambda\_arn) | ARN of an existing Lambda function used to rotate the secret. Null disables managed rotation. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the secret. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rotation_enabled"></a> [rotation\_enabled](#output\_rotation\_enabled) | Whether managed rotation is enabled. |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret (includes the AWS-reserved 6-character suffix). |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | ID of the secret (same as the ARN). |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Configured name of the secret (without the AWS-reserved suffix). |
| <a name="output_secret_version_id"></a> [secret\_version\_id](#output\_secret\_version\_id) | Version id of the initial secret value, or null when initial\_secret\_string was not set. Marked sensitive because the value transitively depends on var.initial\_secret\_string. |
