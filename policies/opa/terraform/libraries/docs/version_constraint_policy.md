# Version Constraint Policy

## Overview
Enforces minimum Terraform version requirement.

## Violations

### Missing versions.tf File
- **Severity:** Error
- **Rule:** Module must contain `versions.tf` file
- **Resolution:** Create `versions.tf` with `required_version = ">= 1.12.1"`

### Invalid Terraform Version Constraint
- **Severity:** Error
- **Rule:** Must specify `required_version = ">= 1.12.1"` in `versions.tf`
- **Resolution:** Update `versions.tf` to include exact constraint

## Required Format
```hcl
terraform {
  required_version = ">= 1.12.1"
}
```

## Purpose
Ensures all modules use compatible Terraform version with required features and bug fixes.
