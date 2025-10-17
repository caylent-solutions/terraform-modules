# Source Policy

## Overview
Enforces that all modules use properly versioned sources from this monorepo only.

## Policy Name
`terraform_module_source_policy`

## Severity
Error

## Violations

### Local Module Source Detected
**Message:** "Local module source detected"

**Details:** Module sources cannot use local paths (relative or absolute)

**Resolution:** Use remote Git sources from the monorepo

**Detected Patterns:**
- Relative paths: `source = "../path"` or `source = "./path"`
- Absolute paths: `source = "/path"`

**Example of violation:**
```hcl
module "local" {
  source = "../other-module"
}
```

### Module Source Must Be From This Monorepo
**Message:** "Module source must be from this monorepo"

**Details:** All module sources must use the Git URL from the Caylent terraform-modules monorepo

**Resolution:** Use module sources from `git::https://github.com/caylent-solutions/terraform-modules.git` only

**Example of violation:**
```hcl
module "external" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
}
```

### Monorepo Module Source Missing Ref Parameter
**Message:** "Monorepo module source missing ref parameter"

**Details:** Monorepo sources must include a `?ref=` parameter with a valid version tag

**Resolution:** Add `?ref=<version>` to the module source URL

**Valid tag format:** `<module-path>/v<major>.<minor>.<patch>`

**Example of violation:**
```hcl
module "no_ref" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/s3"
}

module "invalid_tag" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/s3?ref=v1.0.0"
}
```

## Compliant Examples

### Valid Module Source
```hcl
module "s3" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/s3?ref=providers/aws/primitives/s3/v1.0.0"
}

module "skeleton" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//skeletons/generic-skeleton?ref=skeletons/generic-skeleton/v1.0.0"
}
```

## Tag Format
The `?ref=` parameter must match the repository's tagging pattern:
- Format: `<module-path>/v<major>.<minor>.<patch>`
- Examples:
  - `providers/aws/primitives/vpc/v0.2.0`
  - `skeletons/generic-skeleton/v1.0.0`
  - `providers/github/primitives/repository/v1.2.3`

## Rationale
- Local paths break module portability and versioning
- Monorepo-only sources ensure all modules are tested and approved
- Version tags ensure reproducible deployments

## Scope
Applies to all `.tf` files in module root (excludes `examples/` and `tests/` directories).

## Module Types Using This Policy
All module types
