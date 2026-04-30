# appconfig-application

AWS AppConfig application primitive Terraform module.

Ships:

- `aws_appconfig_application` (the AppConfig namespace)
- Map of `aws_appconfig_environment` resources keyed by logical id, each with optional CloudWatch alarm monitors
- Map of `aws_appconfig_configuration_profile` resources keyed by logical id, supporting feature-flags type (`AWS.AppConfig.FeatureFlags`) and freeform configurations
- Optional per-application `aws_appconfig_deployment_strategy` (LINEAR or EXPONENTIAL growth) with configurable duration, growth factor, and bake time. Default is LINEAR/5min/20% growth (5-step rollout) per Q6 spec.

## Usage

```hcl
module "appconfig" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/appconfig-application?ref=providers/aws/primitives/appconfig-application/v0.1.0"

  name = "telemetry"

  environments = {
    dev  = { name = "dev",  description = "Development" }
    prod = { name = "prod", description = "Production"  }
  }

  configuration_profiles = {
    feature_flags = {
      name = "feature-flags"
      type = "AWS.AppConfig.FeatureFlags"
    }
  }

  create_deployment_strategy = true
  # 5-step LINEAR rollout over 5 minutes, 5-minute bake
  deployment_duration_in_minutes        = 5
  deployment_final_bake_time_in_minutes = 5
  deployment_growth_factor              = 20
  deployment_growth_type                = "LINEAR"

  tags = { Application = "telemetry" }
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/primitives/appconfig-application
```
