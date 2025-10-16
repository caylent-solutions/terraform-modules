# AWS Only Policy

## Overview
Enforces that modules only use AWS as their cloud provider, preventing use of other major cloud providers.

## Policy Name
`terraform_module_aws_only_policy`

## Severity
Error

## Description
This policy ensures all Terraform modules in the repository use AWS resources exclusively. It blocks the use of other major cloud providers (Azure, Google Cloud) while still allowing complementary providers like GitHub, Datadog, etc.

## Violations

### Disallowed Cloud Provider Detected
**Message:** "Disallowed cloud provider detected: {provider}"

**Details:** File {file} contains reference to {provider} provider. Only AWS is allowed among major cloud providers.

**Resolution:** Remove the disallowed provider and use AWS resources instead

**Disallowed Providers:**
- `azurerm` (Azure)
- `azuread` (Azure Active Directory)
- `google` (Google Cloud Platform)
- `google-beta` (Google Cloud Platform Beta)

**Example of violation:**
```hcl
# main.tf
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}
```

## Compliant Examples

### AWS Provider
```hcl
# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
}
```

### AWS with Complementary Providers
```hcl
# main.tf
provider "aws" {
  region = "us-east-1"
}

provider "github" {
  token = var.github_token
}

resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
}

resource "github_repository" "example" {
  name = "example-repo"
}
```

## Rationale
This repository is focused on AWS infrastructure modules. Restricting to AWS ensures:
- Consistent cloud platform across all modules
- Simplified testing and validation
- Clear scope and purpose for the repository
- Prevents accidental multi-cloud configurations

## Module Types Using This Policy
- All module types (skeleton, utility, primitive, collection, reference, data)

## Related Policies
None - this is a standalone policy for cloud provider enforcement
