# AWS AppConfig Application Terraform Module

A Terraform module for creating and managing AWS AppConfig resources including application, environment, configuration profile (feature-flags type), and deployment strategy.

## Overview

This module provisions a complete AWS AppConfig setup optimized for feature flag management with a linear deployment strategy. It creates all four core AppConfig primitives needed for deploying and managing feature flags in your applications.

## Key Features

- **AppConfig Application**: The container for your feature flags configuration
- **AppConfig Environment**: Deployment target (e.g., production, staging, development)
- **Feature Flags Configuration Profile**: Typed configuration profile using `AWS.AppConfig.FeatureFlags`
- **Linear Deployment Strategy**: Configurable linear rollout (defaults to 5 steps over 5 minutes)
- **Comprehensive Tagging**: Automatic resource tagging with custom tag support

## Quick Start

### Basic Usage

```hcl
module "appconfig" {
  source = "git::ssh://git@github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/appconfig-application?ref=providers/aws/primitives/appconfig-application/v0.1.0"

  name                           = "my-app"
  environment_name               = "production"
  configuration_profile_name     = "feature-flags"
  deployment_strategy_name       = "linear-5step-5min"
  deployment_duration_in_minutes = 5
  growth_factor                  = 20
  growth_type                    = "LINEAR"
  replicate_to                   = "NONE"
  final_bake_time_in_minutes     = 0

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Module Structure

```
appconfig-application/
├── examples/
│   └── basic/           # Basic usage example
│       ├── main.tf
│       ├── variables.tf
│       ├── versions.tf
│       ├── terraform.tfvars
│       ├── README.md
│       └── TERRAFORM-DOCS.md
├── tests/
│   ├── basic/           # Tests for the basic example
│   │   ├── module_test.go
│   │   └── README.md
│   └── README.md
├── .cpmenv              # CPM environment configuration
├── .tool-versions       # Tool version pins (asdf/mise)
├── CHANGELOG.md         # Module changelog
├── CODEOWNERS           # GitHub code ownership rules
├── Makefile             # Automation tasks
├── README.md            # This file
├── TERRAFORM-DOCS.md    # Auto-generated documentation
├── VERSION              # Current module version
├── config.tpl           # Configuration template
├── go.mod               # Go module definition for tests
├── locals.tf            # Local values
├── main.tf              # Resource definitions
├── outputs.tf           # Output values
├── test.config          # Test configuration
├── tools.go             # Go tool dependencies
├── variables.tf         # Input variables
└── versions.tf          # Required providers and versions
```

## Examples

- [Basic Example](./examples/basic/): Minimal usage demonstrating a feature-flags AppConfig application with linear deployment strategy

## Inputs

See [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for complete input documentation.

## Outputs

See [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for complete output documentation.

## Testing

Tests use the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

```bash
# Configure CPM and install dependencies
make cpm-configure
make install

# Run all tests
make test

# Lint and format Go test files
make go-lint
make go-format
```

## References

- [AWS AppConfig Documentation](https://docs.aws.amazon.com/appconfig/latest/userguide/what-is-appconfig.html)
- [Terraform AWS Provider - appconfig_application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_application)
- [Terraform AWS Provider - appconfig_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_environment)
- [Terraform AWS Provider - appconfig_configuration_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_configuration_profile)
- [Terraform AWS Provider - appconfig_deployment_strategy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment_strategy)
