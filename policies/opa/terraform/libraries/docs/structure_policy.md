# Structure Policy

## Overview
Enforces required module structure including files, directories, and naming conventions.

## Violations

### Missing Required File
- **Severity:** Error
- **Required Files:**
  - `main.tf`
  - `variables.tf`
  - `versions.tf`
  - `README.md`
  - `TERRAFORM-DOCS.md`
  - `CODEOWNERS`
  - `Makefile`
- **Resolution:** Create the missing file in module root

### Empty Required File
- **Severity:** Error
- **Rule:** Required files cannot be empty
- **Resolution:** Add content to the file

### Disallowed .tf File in Root
- **Severity:** Error
- **Allowed .tf Files:**
  - `main.tf`
  - `variables.tf`
  - `outputs.tf`
  - `versions.tf`
  - `locals.tf`
- **Resolution:** Remove or rename disallowed `.tf` files

### Missing Examples Directory
- **Severity:** Error
- **Rule:** Module must contain `examples/` directory
- **Resolution:** Create `examples/` directory with at least one example implementation

### Missing Tests Directory
- **Severity:** Error
- **Rule:** Module must contain `tests/` directory
- **Resolution:** Create `tests/` directory with required structure

## Purpose
Ensures consistent, complete module structure across all modules in the monorepo.
