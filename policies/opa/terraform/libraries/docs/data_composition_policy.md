# Data Composition Policy

## Overview

The data composition policy enforces rules for Terraform modules that compose data-only functionality from other modules. These modules should orchestrate other modules without defining resources directly.

## Rules

### 1. No Resource Blocks

**Rule:** Data composition modules cannot contain Terraform resource blocks.

**Rationale:** Data composition modules should orchestrate other modules for data retrieval and processing, not define infrastructure directly. This separation ensures clear module boundaries and promotes reusability.

**Example Violation:**
```hcl
# ❌ Bad - data composition module with resource block
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
}
```

**Example Compliance:**
```hcl
# ✅ Good - data composition module using other modules
module "s3_data" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/s3-data?ref=v1.0.0"
  bucket_name = "my-bucket"
}
```

## Policy Details

- **Package:** `terraform.libraries.composition`
- **Policy Name:** `terraform_module_composition_policy`
- **Severity:** `error`

## Usage

This policy is imported by module type-specific policies for data-only modules.

## Testing

Test this policy using the Rego unit test framework:

```bash
make rego-unit-test
```

## Related Policies

- [Data Sources Only Policy](data_sources_only_policy.md) - Enforces data sources only
- [Data File Organization Policy](data_file_organization_policy.md) - Enforces data file structure
- [Composition Policy](composition_policy.md) - Full composition policy with module requirements
