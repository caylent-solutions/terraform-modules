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
| [aws_appconfig_application.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_application) | resource |
| [aws_appconfig_configuration_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_configuration_profile) | resource |
| [aws_appconfig_deployment_strategy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment_strategy) | resource |
| [aws_appconfig_environment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_environment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration_profiles"></a> [configuration\_profiles](#input\_configuration\_profiles) | Map of configuration profiles to create. Key is the logical id; value is `{ name, description (optional), type (e.g. AWS.AppConfig.FeatureFlags or AWS.Freeform), location_uri (optional, defaults to `hosted`) }`. | <pre>map(object({<br/>    name         = string<br/>    description  = optional(string)<br/>    type         = string<br/>    location_uri = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_create_deployment_strategy"></a> [create\_deployment\_strategy](#input\_create\_deployment\_strategy) | Whether to create a per-application deployment strategy. AWS provides a built-in `AppConfig.AllAtOnce` strategy; create one here for finer-grained linear/exponential rollouts. | `bool` | `true` | no |
| <a name="input_deployment_duration_in_minutes"></a> [deployment\_duration\_in\_minutes](#input\_deployment\_duration\_in\_minutes) | Total deployment duration in minutes (0-1440). Default 5 minutes for a 5-step LINEAR rollout (per Q6 spec). | `number` | `5` | no |
| <a name="input_deployment_final_bake_time_in_minutes"></a> [deployment\_final\_bake\_time\_in\_minutes](#input\_deployment\_final\_bake\_time\_in\_minutes) | Bake time after rollout completes (0-1440). | `number` | `5` | no |
| <a name="input_deployment_growth_factor"></a> [deployment\_growth\_factor](#input\_deployment\_growth\_factor) | Percentage of targets advanced per step (1-100). Default 20 produces 5 steps when growth\_type = LINEAR. | `number` | `20` | no |
| <a name="input_deployment_growth_type"></a> [deployment\_growth\_type](#input\_deployment\_growth\_type) | Growth function type. LINEAR (uniform per-step) or EXPONENTIAL (compounding). | `string` | `"LINEAR"` | no |
| <a name="input_deployment_replicate_to"></a> [deployment\_replicate\_to](#input\_deployment\_replicate\_to) | Replication target. NONE (default) or SSM\_DOCUMENT. | `string` | `"NONE"` | no |
| <a name="input_deployment_strategy_description"></a> [deployment\_strategy\_description](#input\_deployment\_strategy\_description) | Description for the deployment strategy. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the AppConfig application. | `string` | `null` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | Map of environments to create. Key is the logical id; value is `{ name, description (optional), monitors (optional list of { alarm_arn, alarm_role_arn (optional) }) }`. | <pre>map(object({<br/>    name        = string<br/>    description = optional(string)<br/>    monitors = optional(list(object({<br/>      alarm_arn      = string<br/>      alarm_role_arn = optional(string)<br/>    })), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the AppConfig application. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the application, environments, configuration profiles, and deployment strategy. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_arn"></a> [application\_arn](#output\_application\_arn) | ARN of the AppConfig application. |
| <a name="output_application_id"></a> [application\_id](#output\_application\_id) | ID of the AppConfig application. |
| <a name="output_application_name"></a> [application\_name](#output\_application\_name) | Name of the AppConfig application. |
| <a name="output_configuration_profile_arns"></a> [configuration\_profile\_arns](#output\_configuration\_profile\_arns) | Map of configuration profile logical ids to AppConfig configuration profile ARNs. |
| <a name="output_configuration_profile_ids"></a> [configuration\_profile\_ids](#output\_configuration\_profile\_ids) | Map of configuration profile logical ids to AppConfig configuration profile ids. |
| <a name="output_deployment_strategy_arn"></a> [deployment\_strategy\_arn](#output\_deployment\_strategy\_arn) | ARN of the deployment strategy, or null when create\_deployment\_strategy = false. |
| <a name="output_deployment_strategy_id"></a> [deployment\_strategy\_id](#output\_deployment\_strategy\_id) | ID of the deployment strategy, or null when create\_deployment\_strategy = false. |
| <a name="output_environment_arns"></a> [environment\_arns](#output\_environment\_arns) | Map of environment logical ids to AppConfig environment ARNs. |
| <a name="output_environment_ids"></a> [environment\_ids](#output\_environment\_ids) | Map of environment logical ids to AppConfig environment ids. |
