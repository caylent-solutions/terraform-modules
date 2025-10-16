# Source Policy

## Overview
Enforces proper module source references and version constraints.

## Violations

### Local Module Source Detected
- **Severity:** Error
- **Rule:** Module sources cannot use local paths (relative or absolute)
- **Detected Patterns:**
  - Relative paths: `source = "../path"` or `source = "./path"`
  - Absolute paths: `source = "/path"`
- **Resolution:** Use remote module sources instead of local paths

### Module Source Without Version Constraint
- **Severity:** Error
- **Rule:** All module sources must include a version constraint
- **Resolution:** Add version constraint to module block

### External Module With Non-Pinned Version
- **Severity:** Error
- **Rule:** External (non-Caylent) modules must use exact version pinning
- **Exemption:** Caylent modules (from `github.com/caylent-solutions/terraform-modules` or `terraform.provider.solutions.caylent.com`)
- **Resolution:** Use exact version format: `version = "1.2.3"`

## Rationale
- Local paths break module portability
- Version constraints ensure reproducible deployments
- Pinned versions for external modules prevent unexpected changes

## Scope
Applies to all `.tf` files in module root (excludes `examples/` and `tests/` directories).
