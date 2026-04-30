# Basic API Gateway REST API Tests

This directory contains tests for the basic example of the `api-gateway-rest-api` module.

## Tests Included

- **TestBasicAPICreation**: Verifies that the REST API is created with a valid ID, ARN, and root resource ID.
- **TestBasicStageOutputs**: Verifies that the deployment stage outputs (stage ID, ARN, invoke URL, execution ARN) are populated.
- **TestBasicExecutionARN**: Verifies the REST API execution ARN format for Lambda permission use.
- **TestBasicResourceCounts**: Verifies the expected resource counts (one API, one stage, one deployment; no domain, WAF, or usage plan).
- **TestBasicTerraformValidate**: Runs `terraform validate` on the basic example to confirm configuration is syntactically valid.
- **TestBasicIdempotency**: Applies the example twice and verifies there are no changes on the second apply.
- **TestBasicTerraformVersion**: Verifies the deployed Terraform version meets the module requirement.
- **TestBasicInvalidLoggingLevel**: Negative test confirming that an invalid `logging_level` value fails at plan time.
- **TestBasicInvalidEndpointType**: Negative test confirming that an invalid `endpoint_type` value fails at plan time.

## Running Tests

```bash
# Run all tests for the module
make test

# Lint Go test files
make go-lint

# Format Go test files
make go-format
```

## Requirements

- Go >= 1.24.4
- Terraform >= 1.12.1
- AWS credentials configured (role ARN via `AWS_GITHUB_ACTIONS_ROLE_ARN` environment variable)
