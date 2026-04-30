<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_appconfig"></a> [appconfig](#module\_appconfig) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration_profile_description"></a> [configuration\_profile\_description](#input\_configuration\_profile\_description) | Description for the AppConfig configuration profile. | `string` | `""` | no |
| <a name="input_configuration_profile_name"></a> [configuration\_profile\_name](#input\_configuration\_profile\_name) | Name for the AppConfig configuration profile. | `string` | n/a | yes |
| <a name="input_deployment_duration_in_minutes"></a> [deployment\_duration\_in\_minutes](#input\_deployment\_duration\_in\_minutes) | Total amount of time in minutes for a deployment to last. | `number` | `5` | no |
| <a name="input_deployment_strategy_description"></a> [deployment\_strategy\_description](#input\_deployment\_strategy\_description) | Description for the AppConfig deployment strategy. | `string` | `""` | no |
| <a name="input_deployment_strategy_name"></a> [deployment\_strategy\_name](#input\_deployment\_strategy\_name) | Name for the AppConfig deployment strategy. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description for the AppConfig application. | `string` | `""` | no |
| <a name="input_environment_description"></a> [environment\_description](#input\_environment\_description) | Description for the AppConfig environment. | `string` | `""` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Name for the AppConfig environment. | `string` | n/a | yes |
| <a name="input_final_bake_time_in_minutes"></a> [final\_bake\_time\_in\_minutes](#input\_final\_bake\_time\_in\_minutes) | The amount of time AppConfig monitors for alarms after the configuration has been deployed to 100% of its targets. | `number` | `0` | no |
| <a name="input_growth_factor"></a> [growth\_factor](#input\_growth\_factor) | The percentage of targets to receive a deployed configuration during each interval. | `number` | `20` | no |
| <a name="input_growth_type"></a> [growth\_type](#input\_growth\_type) | The algorithm used to define how percentage grows over time. | `string` | `"LINEAR"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the AppConfig application. | `string` | n/a | yes |
| <a name="input_replicate_to"></a> [replicate\_to](#input\_replicate\_to) | Where to save the deployment strategy. | `string` | `"NONE"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. | `map(string)` | `{}` | no |

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
<!-- END_TF_DOCS -->
