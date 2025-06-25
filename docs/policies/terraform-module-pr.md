# Terraform Module PR Policy

## Purpose and Scope

This policy enforces that Pull Requests (PRs) must change **only one Terraform module folder** at a time. This ensures that changes are focused, easier to review, and maintain a clean git history.

The policy supports three types of changes:

1. **Add-only**: Creating a new module folder and its contents
2. **Update-only**: Modifying files inside exactly one existing module folder
3. **Delete-only**: Deleting one module folder and its contents

## Integration with Repository

This policy is implemented as a Rego file at `policies/opa/terraform/module/single_module_policy.rego` and is evaluated during PR validation.

The policy is configured via the `monorepo-config.json` file, which defines the module root directories to monitor.

## Edge Case Behavior

- **Non-module files**: This policy only checks files within the defined module roots. PRs should either modify exactly one module OR only non-module files, not both.
- **New providers/generics**: Adding a new provider or generic category is allowed as long as it follows the single module principle.

## Troubleshooting

If your PR fails this policy check:

1. **Multiple modules changed**: Split your changes into separate PRs, one per module.
2. **False positive**: Check if your module path is correctly defined in `pr-policy-config.json`.
3. **Policy evaluation error**: Ensure OPA is installed (`asdf install opa`) and the policy file is valid.

## Documentation
- [Module Structure](terraform-module-structure.md)
- [Module Policies](terraform-module-policies.md)
- [Testing Requirements](terraform-module-testing.md)
- [Complete Workflow Logic](WORKFLOW_LOGIC.md)
- [Main Validation SDLC Guide](main-validation-sdlc.md)
- [Contributing Guidelines](CONTRIBUTING.md)

