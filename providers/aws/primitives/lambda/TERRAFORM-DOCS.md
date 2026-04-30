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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_data"></a> [aws\_data](#module\_aws\_data) | ../../data | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lambda_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_event_source_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_event_invoke_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config) | resource |
| [aws_lambda_function_url.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [aws_lambda_layer_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_provisioned_concurrency_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_provisioned_concurrency_config) | resource |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Map of Lambda aliases | <pre>map(object({<br/>    function_version = string<br/>    description      = optional(string)<br/>    routing_config = optional(object({<br/>      additional_version_weights = map(number)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture for the Lambda function | `list(string)` | <pre>[<br/>  "x86_64"<br/>]</pre> | no |
| <a name="input_code_signing_config_arn"></a> [code\_signing\_config\_arn](#input\_code\_signing\_config\_arn) | ARN of code signing configuration for code integrity | `string` | `null` | no |
| <a name="input_dead_letter_config"></a> [dead\_letter\_config](#input\_dead\_letter\_config) | Dead letter queue configuration for failed invocations | <pre>object({<br/>    target_arn = string<br/>  })</pre> | `null` | no |
| <a name="input_default_batch_size"></a> [default\_batch\_size](#input\_default\_batch\_size) | Default batch size for event source mappings | `number` | `10` | no |
| <a name="input_default_enabled"></a> [default\_enabled](#input\_default\_enabled) | Default enabled state for event source mappings | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Lambda function | `string` | `null` | no |
| <a name="input_enable_parameters_and_secrets_extension"></a> [enable\_parameters\_and\_secrets\_extension](#input\_enable\_parameters\_and\_secrets\_extension) | Enable AWS Parameters and Secrets Lambda Extension for runtime SSM/Secrets access without env vars | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variables for the Lambda function | <pre>object({<br/>    variables = map(string)<br/>  })</pre> | `null` | no |
| <a name="input_environment_from_secrets"></a> [environment\_from\_secrets](#input\_environment\_from\_secrets) | Map of environment variable names to Secrets Manager secret ARNs to fetch and inject | `map(string)` | `{}` | no |
| <a name="input_environment_from_ssm"></a> [environment\_from\_ssm](#input\_environment\_from\_ssm) | Map of environment variable names to SSM parameter names to fetch and inject | `map(string)` | `{}` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | Size of ephemeral storage (/tmp) in MB (512-10240) | `number` | `null` | no |
| <a name="input_event_invoke_configs"></a> [event\_invoke\_configs](#input\_event\_invoke\_configs) | Map of event invoke configurations | <pre>map(object({<br/>    qualifier                    = optional(string)<br/>    maximum_event_age_in_seconds = optional(number)<br/>    maximum_retry_attempts       = optional(number)<br/>    destination_config = optional(object({<br/>      on_failure = optional(object({<br/>        destination = string<br/>      }))<br/>      on_success = optional(object({<br/>        destination = string<br/>      }))<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_event_source_mappings"></a> [event\_source\_mappings](#input\_event\_source\_mappings) | Map of event source mappings to create | <pre>map(object({<br/>    event_source_arn                   = string<br/>    batch_size                         = optional(number)<br/>    enabled                            = optional(bool)<br/>    starting_position                  = optional(string)<br/>    maximum_batching_window_in_seconds = optional(number)<br/>    filter_criteria = optional(object({<br/>      filters = list(object({<br/>        pattern = optional(string)<br/>      }))<br/>    }))<br/>    scaling_config = optional(object({<br/>      maximum_concurrency = number<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_file_system_config"></a> [file\_system\_config](#input\_file\_system\_config) | EFS file system configuration | <pre>object({<br/>    arn              = string<br/>    local_mount_path = string<br/>  })</pre> | `null` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Path to the function's deployment package (Zip only, local file) | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Lambda function | `string` | n/a | yes |
| <a name="input_function_urls"></a> [function\_urls](#input\_function\_urls) | Map of function URL configurations | <pre>map(object({<br/>    authorization_type = string<br/>    qualifier          = optional(string)<br/>    cors = optional(object({<br/>      allow_credentials = optional(bool)<br/>      allow_headers     = optional(list(string))<br/>      allow_methods     = optional(list(string))<br/>      allow_origins     = optional(list(string))<br/>      expose_headers    = optional(list(string))<br/>      max_age           = optional(number)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Function entrypoint in your code (Zip only) | `string` | `null` | no |
| <a name="input_image_config"></a> [image\_config](#input\_image\_config) | Container image configuration (Image only) | <pre>object({<br/>    command           = optional(list(string))<br/>    entry_point       = optional(list(string))<br/>    working_directory = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | ECR image URI containing the function's deployment package (Image only) | `string` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of KMS key to encrypt environment variables | `string` | `null` | no |
| <a name="input_layer_versions"></a> [layer\_versions](#input\_layer\_versions) | Map of Lambda layer versions to create | <pre>map(object({<br/>    filename            = optional(string)<br/>    s3_bucket           = optional(string)<br/>    s3_key              = optional(string)<br/>    s3_object_version   = optional(string)<br/>    compatible_runtimes = optional(list(string))<br/>    description         = optional(string)<br/>    license_info        = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer ARNs (Zip only) | `list(string)` | `null` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | CloudWatch Logs configuration | <pre>object({<br/>    log_format            = string<br/>    log_group             = optional(string)<br/>    system_log_level      = optional(string)<br/>    application_log_level = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB Lambda function has access to | `number` | `128` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | Lambda deployment package type (Zip or Image) | `string` | `"Zip"` | no |
| <a name="input_parameters_and_secrets_extension_config"></a> [parameters\_and\_secrets\_extension\_config](#input\_parameters\_and\_secrets\_extension\_config) | Configuration for Parameters and Secrets Lambda Extension | <pre>object({<br/>    http_port                   = optional(number, 2773)<br/>    secrets_manager_timeout     = optional(number, 0)<br/>    ssm_parameter_store_timeout = optional(number, 0)<br/>    max_connections             = optional(number, 3)<br/>    cache_enabled               = optional(string, "true")<br/>    cache_size                  = optional(string, "1000")<br/>  })</pre> | `{}` | no |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | Map of Lambda permissions to create | <pre>map(object({<br/>    statement_id       = string<br/>    action             = string<br/>    principal          = string<br/>    source_arn         = optional(string)<br/>    source_account     = optional(string)<br/>    event_source_token = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_provisioned_concurrent_executions"></a> [provisioned\_concurrent\_executions](#input\_provisioned\_concurrent\_executions) | Map of provisioned concurrency configurations | <pre>map(object({<br/>    provisioned_concurrent_executions = number<br/>    qualifier                         = string<br/>  }))</pre> | `{}` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version | `bool` | `false` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Amount of reserved concurrent executions for this Lambda function | `number` | `-1` | no |
| <a name="input_role"></a> [role](#input\_role) | ARN of the IAM role for Lambda execution | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime environment for the Lambda function (Zip only) | `string` | `null` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket containing the function's deployment package (Zip only, S3 object) | `string` | `null` | no |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | S3 key of the function's deployment package (Zip only, S3 object) | `string` | `null` | no |
| <a name="input_s3_object_version"></a> [s3\_object\_version](#input\_s3\_object\_version) | S3 object version of the function's deployment package (Zip only, S3 object) | `string` | `null` | no |
| <a name="input_source_code_hash"></a> [source\_code\_hash](#input\_source\_code\_hash) | Base64-encoded SHA256 hash of the package file (Zip only) | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the Lambda function | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Amount of time Lambda function has to run in seconds | `number` | `3` | no |
| <a name="input_tracing_mode"></a> [tracing\_mode](#input\_tracing\_mode) | X-Ray tracing mode for the Lambda function | `string` | `"Active"` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration for the Lambda function | <pre>object({<br/>    subnet_ids         = list(string)<br/>    security_group_ids = list(string)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias_arns"></a> [alias\_arns](#output\_alias\_arns) | Map of alias ARNs |
| <a name="output_alias_invoke_arns"></a> [alias\_invoke\_arns](#output\_alias\_invoke\_arns) | Map of alias invoke ARNs |
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the Lambda function |
| <a name="output_code_sha256"></a> [code\_sha256](#output\_code\_sha256) | Base64-encoded SHA256 hash of the package |
| <a name="output_event_source_mapping_states"></a> [event\_source\_mapping\_states](#output\_event\_source\_mapping\_states) | Map of event source mapping states |
| <a name="output_event_source_mapping_uuids"></a> [event\_source\_mapping\_uuids](#output\_event\_source\_mapping\_uuids) | Map of event source mapping UUIDs |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the Lambda function |
| <a name="output_function_urls"></a> [function\_urls](#output\_function\_urls) | Map of function URL endpoints |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | ARN to be used for invoking Lambda function from API Gateway |
| <a name="output_last_modified"></a> [last\_modified](#output\_last\_modified) | Date the function was last modified |
| <a name="output_layer_version_arns"></a> [layer\_version\_arns](#output\_layer\_version\_arns) | Map of layer version ARNs |
| <a name="output_provisioned_concurrency_configs"></a> [provisioned\_concurrency\_configs](#output\_provisioned\_concurrency\_configs) | Map of provisioned concurrency configuration ARNs |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | ARN identifying your Lambda function version |
| <a name="output_source_code_size"></a> [source\_code\_size](#output\_source\_code\_size) | Size of the function deployment package in bytes |
| <a name="output_version"></a> [version](#output\_version) | Latest published version of your Lambda function |
