# Makefile Policy

## Overview
Ensures module Makefile matches the skeleton template.

## Violations

### Missing Makefile
- **Severity:** Error
- **Rule:** Module must contain a Makefile
- **Resolution:** Add a Makefile matching `skeletons/generic-skeleton/Makefile`

### Makefile Doesn't Match Skeleton
- **Severity:** Error
- **Rule:** Makefile content must exactly match skeleton
- **Resolution:** Copy Makefile from `skeletons/generic-skeleton/Makefile`

## Purpose
Ensures consistent build, test, and deployment commands across all modules.
