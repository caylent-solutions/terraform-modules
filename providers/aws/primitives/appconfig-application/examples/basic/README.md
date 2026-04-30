# Basic AppConfig Application Example

This example demonstrates the basic usage of the AppConfig application module with a feature-flags configuration profile and linear deployment strategy.

## Usage

```hcl
module "appconfig" {
  source = "../../"

  name                              = "my-app"
  environment_name                  = "production"
  configuration_profile_name        = "feature-flags"
  deployment_strategy_name          = "linear-5step-5min"
  deployment_duration_in_minutes    = 5
  growth_factor                     = 20
  growth_type                       = "LINEAR"
  replicate_to                      = "NONE"
  final_bake_time_in_minutes        = 0
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.12.1 |
| aws | ~> 6.0.0 |

## Required Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name for the AppConfig application | `string` | n/a | yes |
| environment_name | Name for the AppConfig environment | `string` | n/a | yes |
| configuration_profile_name | Name for the AppConfig configuration profile | `string` | n/a | yes |
| deployment_strategy_name | Name for the AppConfig deployment strategy | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| application_id | ID of the AppConfig application |
| application_arn | ARN of the AppConfig application |
| application_name | Name of the AppConfig application |
| environment_id | ID of the AppConfig environment |
| environment_arn | ARN of the AppConfig environment |
| environment_name | Name of the AppConfig environment |
| configuration_profile_id | ID of the AppConfig configuration profile |
| configuration_profile_arn | ARN of the AppConfig configuration profile |
| configuration_profile_name | Name of the AppConfig configuration profile |
| deployment_strategy_id | ID of the AppConfig deployment strategy |
| deployment_strategy_arn | ARN of the AppConfig deployment strategy |
| deployment_strategy_name | Name of the AppConfig deployment strategy |
