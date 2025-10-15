# GitHub Only Provider Restriction Policy

## Overview
This policy ensures that Terraform modules only use the GitHub provider and do not reference other major cloud providers (AWS, Azure, Google Cloud).

## Policy Details
- **Package**: `terraform.libraries.github_only_provider_restriction`
- **Severity**: Error
- **Policy Name**: `terraform_module_github_only_policy`

## What It Checks
The policy scans all `.tf` files in the module and checks for `provider` blocks that reference disallowed cloud providers:
- `aws` - Amazon Web Services
- `azurerm` - Microsoft Azure Resource Manager
- `google` - Google Cloud Platform
- `google-beta` - Google Cloud Platform Beta
- `azuread` - Azure Active Directory

## Allowed Providers
- `github` - GitHub provider (primary)
- Utility providers like `random`, `local`, `null`, `time`, etc.

## Violation Example
```hcl
# This will violate the policy
provider "aws" {
  region = "us-west-2"
}
```

## Compliant Example
```hcl
# This is compliant
provider "github" {
  owner = "my-organization"
}
```

## Resolution
Remove any disallowed cloud provider blocks and use GitHub resources instead. If you need to manage cloud resources, use the appropriate provider-specific module type (e.g., AWS modules should be in `providers/aws/`).

## Usage
This policy is automatically applied to all GitHub provider module types:
- `providers/github/primitives/*`
- `providers/github/collections/*`
- `providers/github/references/*`
- `providers/github/data/*`
