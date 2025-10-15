# Naming Policy

## Overview
Prevents dynamic resource name generation to ensure predictable resource naming.

## Violations

### Dynamic Resource Name Generation
- **Severity:** Error
- **Rule:** Resource names cannot be dynamically generated using interpolation or functions
- **Detected Patterns:**
  - Interpolation in resource names: `resource "type" "${var.name}"`
  - Functions in resource names: `concat`, `format`, `join`, `lower`, `upper`, `replace`, `substr`, `uuid`, `timestamp`
- **Resolution:** Use variables for resource names instead of dynamic generation

## Rationale
Dynamic names make resources harder to track, debug, and manage. Static or variable-based names provide predictability.

## Scope
Applies to all `.tf` files in module root (excludes `examples/` and `tests/` directories).
