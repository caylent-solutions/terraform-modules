# File Organization Policy

## Overview
Enforces proper organization of Terraform declarations into specific files.

## Violations

### Variable Declarations in Wrong File
- **Severity:** Error
- **Rule:** Variable declarations must only be in `variables.tf`
- **Resolution:** Move all variable declarations to `variables.tf`

### Output Declarations in Wrong File
- **Severity:** Error
- **Rule:** Output declarations must only be in `outputs.tf`
- **Resolution:** Move all output declarations to `outputs.tf`

### Terraform Blocks in Wrong File
- **Severity:** Error
- **Rule:** Terraform blocks must only be in `versions.tf`
- **Resolution:** Move all terraform blocks to `versions.tf`

### Required Providers in Wrong File
- **Severity:** Error
- **Rule:** Required providers blocks must only be in `versions.tf`
- **Resolution:** Move all required_providers blocks to `versions.tf`

### Locals Blocks in Wrong File
- **Severity:** Error
- **Rule:** Locals blocks must only be in `locals.tf`
- **Resolution:** Move all locals blocks to `locals.tf`

## Scope
Applies to all `.tf` files in module root (excludes `examples/` and `tests/` directories).
