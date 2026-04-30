# AWS Constants Data Module

This data module provides centralized access to AWS service constants and patterns that are used across multiple Terraform modules. The constants are organized by AWS service and can be validated against AWS APIs.

## Purpose

- Centralize AWS service constants to improve maintainability
- Provide a single source of truth for AWS API constants
- Enable validation of constants against AWS APIs through testing
- Reduce duplication of hardcoded values across modules

## Constants Included

### IAM Identity Center
- Principal types (GROUP, USER)
- Identity provider types (INTERNAL, EXTERNAL, GOOGLE)
- Permission set configuration keys
- Policy attachment property names

### General AWS
- Account ID format validation patterns
- Common array indices
- Default values
- Format string patterns

### Lambda Extension (`lambda_extension`)
- AWS Parameters and Secrets Lambda Extension environment variable names
  (`PARAMETERS_SECRETS_EXTENSION_HTTP_PORT`,
  `PARAMETERS_SECRETS_EXTENSION_CACHE_ENABLED`,
  `PARAMETERS_SECRETS_EXTENSION_CACHE_SIZE`,
  `PARAMETERS_SECRETS_EXTENSION_MAX_CONNECTIONS`,
  `SECRETS_MANAGER_TIMEOUT_MILLIS`, `SSM_PARAMETER_STORE_TIMEOUT_MILLIS`)
- AWS-managed layer version pin (currently `11`)
- Layer name and ARN pattern for x86_64 and arm64 architectures
  (`AWS-Parameters-and-Secrets-Lambda-Extension`,
  `AWS-Parameters-and-Secrets-Lambda-Extension-Arm64`)

Consumed by the `lambda` primitive when
`enable_parameters_and_secrets_extension = true`.

## Usage

```hcl
module "aws_constants" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/data/aws-constants?ref=providers/aws/data/aws-constants/v1.0.0"
}

# Use the constants in your configuration
resource "aws_ssoadmin_account_assignment" "example" {
  principal_type = module.aws_constants.iam_identity_center_principal_types.user
  # ... other configuration
}
```

## Testing Strategy

The constants in this module are organized by AWS service and API endpoint to enable comprehensive testing:

- **IAM Identity Center constants**: Can be validated against AWS SSO Admin API
- **General constants**: Can be validated against AWS documentation and patterns

Future tests will query the relevant AWS APIs to ensure constants remain accurate as AWS services evolve.