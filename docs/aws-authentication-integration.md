# AWS Authentication Integration with GitHub Actions

## Purpose

This repository creates and releases Terraform modules for AWS infrastructure. The AWS authentication integration enables automated testing and validation of these modules without deploying long-lived production infrastructure.

## Integration Overview

### Module Testing Only
- **No Production Deployments**: This repository does not deploy production infrastructure
- **Module Validation**: AWS credentials are used solely for testing Terraform module functionality
- **Temporary Resources**: Any AWS resources created during testing are ephemeral and cleaned up automatically

### Authentication Trigger
AWS authentication is automatically enabled when:
- Module path starts with `providers/aws/`
- Terraform operations require AWS API access (`terraform plan`, `terraform apply` in tests)

### OIDC Integration Flow
1. **Detection**: Workflow detects AWS module path
2. **Token Request**: GitHub Actions requests OIDC token
3. **Role Assumption**: Token used to assume `terraform-modules-GitHubActionsTestRole`
4. **Credential Export**: Temporary AWS credentials available to subsequent steps
5. **Module Testing**: Terraform commands execute with AWS access
6. **Cleanup**: Credentials expire automatically, test resources destroyed

## Security Model

### Dedicated Test Account
- Isolated AWS account for GitHub Actions testing
- No access to production environments
- All resources are temporary and test-focused

### Role-Based Access
- Single IAM role: `terraform-modules-GitHubActionsTestRole`
- AdministratorAccess for comprehensive module testing
- Trust policy restricts access to this specific repository

### Audit and Monitoring
- CloudTrail logging of all AWS API calls
- Unique session names per workflow run
- No persistent credentials stored in GitHub

## Workflow Integration Points

### PR Validation
- `terraform plan` execution for AWS modules
- Module test execution (terratest)
- Security scanning and validation

### Post-Merge Validation
- Re-validation of merged changes
- Comprehensive testing before release

## Test Resource Management

### Ephemeral Nature
- All AWS resources created during testing are temporary
- Automatic cleanup after test completion
- No persistent infrastructure maintained

### Resource Isolation
- Test resources use unique naming conventions
- Isolated from any production resources
- Scoped to test execution timeframe