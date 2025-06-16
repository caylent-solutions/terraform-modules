# Monorepo Code PR Policy

## Purpose and Scope

The PR validation workflow enforces that Pull Requests (PRs) must follow one of these patterns:
1. Modify exactly one Terraform module (no non-module files allowed), OR
2. Modify only non-module files (no module files allowed)

This ensures that infrastructure code changes are kept separate from repository maintenance changes.

## Implementation

This policy is enforced by the `detect-module-changes` script in the PR validation workflow. The script checks if changes match module patterns and then:
1. If files from multiple modules are detected, it fails with an error
2. If files from exactly one module AND non-module files are detected, it fails with an error
3. If files from exactly one module (and no non-module files) are detected, it triggers the Terraform module validation workflow
4. If only non-module files are detected, it triggers the non-Terraform validation workflow

The workflow branches into two mutually exclusive paths based on whether module files are detected.

## Edge Case Behavior

- **Multiple module changes**: PRs that modify files in multiple modules will be rejected.
- **Single module + non-module files**: PRs that modify both a module and non-module files will be rejected with an error message.
- **Only non-module files**: PRs that only modify non-module files will run the non-Terraform validation workflow.

## Troubleshooting

If your PR fails this check:

1. **Multiple modules detected**: Split your changes into separate PRs - one for each module.
2. **Mixed module and non-module changes**: Split your changes into separate PRs - one for module changes and one for non-module changes.
3. **False positive**: Check if your module paths are correctly defined in `monorepo-config.json`.

