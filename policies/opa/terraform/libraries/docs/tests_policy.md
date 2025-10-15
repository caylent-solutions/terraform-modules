# Tests Policy

## Overview
Enforces comprehensive testing requirements using Terraform Terratest Framework.

## Violations

### Missing Test Directory for Example
- **Severity:** Error
- **Rule:** Each example must have corresponding test directory
- **Resolution:** Create `tests/<example-name>/` with `module_test.go` and `README.md`

### Missing Common Test Directory
- **Severity:** Error
- **Rule:** Modules with multiple examples must have `tests/common/` directory
- **Resolution:** Create `tests/common/` with `module_test.go` and `README.md`

### Missing Required File in Test Directory
- **Severity:** Error
- **Required Files:**
  - `module_test.go`
  - `README.md`
- **Resolution:** Create missing file in test directory

### Missing README.md in Tests Root
- **Severity:** Error
- **Rule:** `tests/` directory must contain `README.md`
- **Resolution:** Create `README.md` in `tests/` directory

### Empty Required Test File
- **Severity:** Error
- **Rule:** `module_test.go` and `README.md` cannot be empty
- **Resolution:** Add content to the file

### Missing Terratest Framework Import
- **Severity:** Error
- **Rule:** Test files must import `github.com/caylent-solutions/terraform-terratest-framework`
- **Resolution:** Add framework import to test file

### Missing go.mod File
- **Severity:** Error
- **Rule:** Module must contain `go.mod` with terratest framework dependency
- **Resolution:** Create `go.mod` with framework dependency

### Missing test.config File
- **Severity:** Error
- **Rule:** Module must contain `test.config` file
- **Resolution:** Create `test.config` with test configuration

### Missing Terratest Framework Dependency
- **Severity:** Error
- **Rule:** `go.mod` must include terratest framework dependency
- **Resolution:** Add `github.com/caylent-solutions/terraform-terratest-framework` to `go.mod`

### Missing TERRATEST_IDEMPOTENCY Setting
- **Severity:** Error
- **Rule:** `test.config` must include `TERRATEST_IDEMPOTENCY=` setting
- **Resolution:** Add `TERRATEST_IDEMPOTENCY=true` or `TERRATEST_IDEMPOTENCY=false`

### Invalid TERRATEST_IDEMPOTENCY Value
- **Severity:** Error
- **Rule:** `TERRATEST_IDEMPOTENCY` must be `true` or `false`
- **Resolution:** Set to either `true` or `false`

## Purpose
Ensures all modules have comprehensive, framework-based tests for reliability and maintainability.
