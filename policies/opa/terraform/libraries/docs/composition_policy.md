# Composition Policy

## Overview

The composition policy enforces rules for Terraform modules that compose functionality from other modules (collection and reference modules). These modules should orchestrate other modules rather than define resources directly.

## Rules

### 1. No Resource Blocks

**Rule:** Composition modules cannot contain Terraform resource blocks.

**Rationale:** Composition modules should orchestrate other modules, not define infrastructure directly. This separation ensures clear module boundaries and promotes reusability.

**Example Violation:**
```hcl
# ❌ Bad - composition module with resource block
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket"
}
```

**Example Compliance:**
```hcl
# ✅ Good - composition module using other modules
module "s3_bucket" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/s3?ref=v1.0.0"
  bucket_name = "my-bucket"
}
```

### 2. Require Module Sources

**Rule:** Composition modules must use at least one source module.

**Rationale:** Composition modules exist to combine and orchestrate other modules. A composition module without any module sources serves no purpose.

**Example Violation:**
```hcl
# ❌ Bad - composition module with no modules
variable "bucket_name" {
  type = string
}

output "bucket_name" {
  value = var.bucket_name
}
```

**Example Compliance:**
```hcl
# ✅ Good - composition module using modules
module "s3_bucket" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/s3?ref=v1.0.0"
  bucket_name = var.bucket_name
}

module "cloudfront" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/cloudfront?ref=v1.0.0"
  origin_bucket = module.s3_bucket.bucket_id
}
```

## Policy Details

- **Package:** `terraform.libraries.composition`
- **Policy Name:** `terraform_module_composition_policy`
- **Severity:** `error`

## Usage

This policy is imported by module type-specific policies:

```rego
package terraform.module_types.collection.composition

import data.terraform.libraries.composition

violation[result] {
  result := data.terraform.libraries.composition.violation[_]
}
```

## Testing

Test this policy using the Rego unit test framework:

```bash
make rego-unit-test
```

## Related Policies

- [Structure Policy](structure_policy.md) - Enforces module directory structure
- [Nested Modules Policy](nested_modules_policy.md) - Validates nested module usage
- [Source Policy](source_policy.md) - Validates module source references
