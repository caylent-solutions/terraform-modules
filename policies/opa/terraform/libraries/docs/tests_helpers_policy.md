# Tests Helpers Policy

## Overview
Validates test helper files when `tests/helpers/` directory exists.

## Violations

### Missing helpers.go
- **Severity:** Error
- **Rule:** If `tests/helpers/` exists, it must contain `helpers.go`
- **Resolution:** Create `helpers.go` file in `tests/helpers/` directory

### Missing README.md in Helpers
- **Severity:** Error
- **Rule:** If `tests/helpers/` exists, it must contain `README.md`
- **Resolution:** Create `README.md` file in `tests/helpers/` directory

### Empty helpers.go File
- **Severity:** Error
- **Rule:** `helpers.go` cannot be empty
- **Resolution:** Add helper functions to `helpers.go`

## Purpose
Ensures test helpers are properly documented and implemented when present.

## Note
This policy only triggers if `tests/helpers/` directory exists. The directory itself is optional.
