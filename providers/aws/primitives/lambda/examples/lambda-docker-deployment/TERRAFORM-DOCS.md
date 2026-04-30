## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.0.0, < 3.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0, < 4.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0, < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | >= 2.0.0, < 3.0.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.0.0, < 4.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0, < 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_efs_access_point.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_file_system.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_extension](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_code_signing_config.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_code_signing_config) | resource |
| [aws_secretsmanager_secret.api_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.api_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_signer_signing_profile.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/signer_signing_profile) | resource |
| [aws_ssm_parameter.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_subnet.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [null_resource.docker_build_push](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.layer](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture | `list(string)` | <pre>[<br/>  "x86_64"<br/>]</pre> | no |
| <a name="input_batch_size"></a> [batch\_size](#input\_batch\_size) | Event source batch size | `number` | `10` | no |
| <a name="input_enable_event_source"></a> [enable\_event\_source](#input\_enable\_event\_source) | Whether to create SQS event source | `bool` | `true` | no |
| <a name="input_enable_vpc"></a> [enable\_vpc](#input\_enable\_vpc) | Whether to enable VPC configuration | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables for the function | `map(string)` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Lambda function | `string` | n/a | yes |
| <a name="input_image_command"></a> [image\_command](#input\_image\_command) | Command override for the container image | `list(string)` | `null` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Function memory in MB | `number` | `512` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | VPC security group IDs | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | VPC subnet IDs | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Function timeout in seconds | `number` | `60` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_code_signing_config_arn"></a> [code\_signing\_config\_arn](#output\_code\_signing\_config\_arn) | ARN of code signing configuration |
| <a name="output_ecr_repository_url"></a> [ecr\_repository\_url](#output\_ecr\_repository\_url) | URL of the ECR repository |
| <a name="output_efs_file_system_id"></a> [efs\_file\_system\_id](#output\_efs\_file\_system\_id) | ID of the EFS file system |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | ARN of the Lambda function |
| <a name="output_function_invoke_arn"></a> [function\_invoke\_arn](#output\_function\_invoke\_arn) | Invoke ARN of the Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the Lambda function |
| <a name="output_function_version"></a> [function\_version](#output\_function\_version) | Version of the Lambda function |
| <a name="output_layer_version_arn"></a> [layer\_version\_arn](#output\_layer\_version\_arn) | ARN of the custom layer |
