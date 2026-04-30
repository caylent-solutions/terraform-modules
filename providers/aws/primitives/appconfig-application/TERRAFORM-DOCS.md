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
| [aws_appconfig_application.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_application) | resource |
| [aws_appconfig_configuration_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_configuration_profile) | resource |
| [aws_appconfig_deployment_strategy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment_strategy) | resource |
| [aws_appconfig_environment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_environment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input__configuration_profile_location_uri"></a> [\_configuration\_profile\_location\_uri](#input\_\_configuration\_profile\_location\_uri) | AWS API constant: location URI for hosted configuration profiles. | `string` | `"hosted"` | no |
| <a name="input__configuration_profile_type"></a> [\_configuration\_profile\_type](#input\_\_configuration\_profile\_type) | AWS API constant: configuration profile type for feature flags. | `string` | `"AWS.AppConfig.FeatureFlags"` | no |
| <a name="input_configuration_profile_description"></a> [configuration\_profile\_description](#input\_configuration\_profile\_description) | (Optional) Description for the AppConfig configuration profile. | `string` | `""` | no |
| <a name="input_configuration_profile_name"></a> [configuration\_profile\_name](#input\_configuration\_profile\_name) | (Required) Name for the AppConfig configuration profile. | `string` | n/a | yes |
| <a name="input_deployment_duration_in_minutes"></a> [deployment\_duration\_in\_minutes](#input\_deployment\_duration\_in\_minutes) | (Optional) Total amount of time in minutes for a deployment to last. Defaults to 5 minutes (linear 5-step over 5 minutes). | `number` | `5` | no |
| <a name="input_deployment_strategy_description"></a> [deployment\_strategy\_description](#input\_deployment\_strategy\_description) | (Optional) Description for the AppConfig deployment strategy. | `string` | `""` | no |
| <a name="input_deployment_strategy_name"></a> [deployment\_strategy\_name](#input\_deployment\_strategy\_name) | (Required) Name for the AppConfig deployment strategy. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Description for the AppConfig application. | `string` | `""` | no |
| <a name="input_environment_description"></a> [environment\_description](#input\_environment\_description) | (Optional) Description for the AppConfig environment. | `string` | `""` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | (Required) Name for the AppConfig environment. | `string` | n/a | yes |
| <a name="input_final_bake_time_in_minutes"></a> [final\_bake\_time\_in\_minutes](#input\_final\_bake\_time\_in\_minutes) | (Optional) The amount of time AppConfig monitors for Amazon CloudWatch alarms after the configuration has been deployed to 100% of its targets, before considering the deployment to be complete. | `number` | `0` | no |
| <a name="input_growth_factor"></a> [growth\_factor](#input\_growth\_factor) | (Optional) The percentage of targets to receive a deployed configuration during each interval. Defaults to 20 (linear 5-step: 5 steps x 20% = 100%). | `number` | `20` | no |
| <a name="input_growth_type"></a> [growth\_type](#input\_growth\_type) | (Optional) The algorithm used to define how percentage grows over time. Valid values: LINEAR, EXPONENTIAL. | `string` | `"LINEAR"` | no |
| <a name="input_managed_by_tag"></a> [managed\_by\_tag](#input\_managed\_by\_tag) | (Optional) Value for the ManagedBy tag. | `string` | `"terraform"` | no |
| <a name="input_module_tag"></a> [module\_tag](#input\_module\_tag) | (Optional) Value for the Module tag. | `string` | `"appconfig-application"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name for the AppConfig application and associated resources. | `string` | n/a | yes |
| <a name="input_replicate_to"></a> [replicate\_to](#input\_replicate\_to) | (Optional) Where to save the deployment strategy. Valid values: NONE, SSM\_DOCUMENT. | `string` | `"NONE"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to the resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_arn"></a> [application\_arn](#output\_application\_arn) | The ARN of the AppConfig application. |
| <a name="output_application_id"></a> [application\_id](#output\_application\_id) | The ID of the AppConfig application. |
| <a name="output_application_name"></a> [application\_name](#output\_application\_name) | The name of the AppConfig application. |
| <a name="output_configuration_profile_arn"></a> [configuration\_profile\_arn](#output\_configuration\_profile\_arn) | The ARN of the AppConfig configuration profile. |
| <a name="output_configuration_profile_id"></a> [configuration\_profile\_id](#output\_configuration\_profile\_id) | The configuration profile ID. |
| <a name="output_configuration_profile_name"></a> [configuration\_profile\_name](#output\_configuration\_profile\_name) | The name of the AppConfig configuration profile. |
| <a name="output_deployment_strategy_arn"></a> [deployment\_strategy\_arn](#output\_deployment\_strategy\_arn) | The ARN of the AppConfig deployment strategy. |
| <a name="output_deployment_strategy_id"></a> [deployment\_strategy\_id](#output\_deployment\_strategy\_id) | The ID of the AppConfig deployment strategy. |
| <a name="output_deployment_strategy_name"></a> [deployment\_strategy\_name](#output\_deployment\_strategy\_name) | The name of the AppConfig deployment strategy. |
| <a name="output_environment_arn"></a> [environment\_arn](#output\_environment\_arn) | The ARN of the AppConfig environment. |
| <a name="output_environment_id"></a> [environment\_id](#output\_environment\_id) | The ID of the AppConfig environment. |
| <a name="output_environment_name"></a> [environment\_name](#output\_environment\_name) | The name of the AppConfig environment. |
