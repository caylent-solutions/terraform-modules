# Basic Example Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_appconfig"></a> [appconfig](#module\_appconfig) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Base AppConfig application name (a random suffix is appended). | `string` | n/a | yes |
| <a name="input_deployment_duration_in_minutes"></a> [deployment\_duration\_in\_minutes](#input\_deployment\_duration\_in\_minutes) | Total deployment duration in minutes. | `number` | `5` | no |
| <a name="input_deployment_final_bake_time_in_minutes"></a> [deployment\_final\_bake\_time\_in\_minutes](#input\_deployment\_final\_bake\_time\_in\_minutes) | Bake time after rollout completes. | `number` | `5` | no |
| <a name="input_deployment_growth_factor"></a> [deployment\_growth\_factor](#input\_deployment\_growth\_factor) | Percentage of targets advanced per step. | `number` | `20` | no |
| <a name="input_deployment_growth_type"></a> [deployment\_growth\_type](#input\_deployment\_growth\_type) | LINEAR or EXPONENTIAL growth function. | `string` | `"LINEAR"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_id"></a> [application\_id](#output\_application\_id) | AppConfig application ID. |
| <a name="output_application_name"></a> [application\_name](#output\_application\_name) | AppConfig application name. |
| <a name="output_configuration_profile_ids"></a> [configuration\_profile\_ids](#output\_configuration\_profile\_ids) | Map of configuration profile logical ids to AppConfig configuration profile ids. |
| <a name="output_deployment_strategy_id"></a> [deployment\_strategy\_id](#output\_deployment\_strategy\_id) | Deployment strategy ID. |
| <a name="output_environment_ids"></a> [environment\_ids](#output\_environment\_ids) | Map of environment logical ids to AppConfig environment ids. |
<!-- END_TF_DOCS -->