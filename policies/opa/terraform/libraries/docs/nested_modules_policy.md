# Nested Modules Policy

## Overview
Prohibits nested Terraform modules to maintain flat module structure.

## Violations

### Nested Terraform Files Detected
- **Severity:** Error
- **Rule:** `.tf` files must only exist in module root, not in subdirectories
- **Exclusions:** `examples/` and `tests/` directories are allowed to have nested `.tf` files
- **Resolution:** Move Terraform files to module root or restructure code

## Rationale
Nested modules increase complexity and make module structure harder to understand. Flat structure is clearer and more maintainable.

## Detection
Identifies any `.tf` file in a subdirectory (containing `/` in relative path) outside of `examples/` and `tests/`.
