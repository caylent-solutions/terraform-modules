# Basic AppConfig Application Tests

This directory contains tests specific to the basic example that demonstrate standard AppConfig module functionality.

## Tests Included

- **TestBasicAppConfigApplication**: Verifies the AppConfig application is created with expected properties and correct ARN format
- **TestBasicAppConfigEnvironment**: Verifies the AppConfig environment is created and linked to the application
- **TestBasicAppConfigConfigurationProfile**: Verifies the feature-flags configuration profile is created correctly
- **TestBasicAppConfigDeploymentStrategy**: Verifies the linear deployment strategy is created with correct settings
- **TestBasicAppConfigResourceCounts**: Validates that exactly one of each resource type is created
- **TestBasicAppConfigStateContents**: Verifies all resources are present in Terraform state
- **TestBasicAppConfigIdempotency**: Tests idempotency via the framework's AssertIdempotent
- **TestBasicAppConfigTerraformValidate**: Runs terraform validate on the basic example
- **TestBasicAppConfigTerraformVersion**: Verifies minimum Terraform version requirement

## Running Tests

```bash
# Run basic tests specifically
go test ./tests/basic -v

# Run all tests
make test

# Run with specific settings
TERRATEST_IDEMPOTENCY=true make test
```

## Test Coverage

These tests verify:
- AppConfig application creation with correct ARN format
- AppConfig environment linked to application
- Feature-flags type configuration profile
- Linear deployment strategy (5 steps over 5 minutes)
- Resource count assertions (one of each resource)
- State contents verification
- Idempotency
