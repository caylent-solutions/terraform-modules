# Terraform Module PR Policy

## Purpose and Scope

This policy enforces that Pull Requests (PRs) must change **only one Terraform module folder** at a time. This ensures that changes are focused, easier to review, and maintain a clean git history.

The policy supports three types of changes:

1. **Add-only**: Creating a new module folder and its contents
2. **Update-only**: Modifying files inside exactly one existing module folder
3. **Delete-only**: Deleting one module folder and its contents

## Integration with Repository

This policy is implemented as a Rego file at `policies/opa/global/terraform_module_policy.rego` and is evaluated during PR validation using the `make pr-opa-policy-test` command.

The policy is configured via the `pr-policy-config.json` file, which defines the module root directories to monitor.

## Example Usage

To test your changes locally before submitting a PR:

```bash
# Update the test_changed_files in pr-policy-config.json to match your changes
# Then run:
make pr-opa-policy-test
```

In CI/CD pipelines, this policy is automatically evaluated against the actual changed files in the PR.

## Edge Case Behavior

- **Non-module files**: This policy only checks files within the defined module roots. Changes to files outside module roots are handled by the monorepo code policy.
- **New providers/generics**: Adding a new provider or generic category is allowed as long as it follows the single module principle.

## Troubleshooting

If your PR fails this policy check:

1. **Multiple modules changed**: Split your changes into separate PRs, one per module.
2. **False positive**: Check if your module path is correctly defined in `pr-policy-config.json`.
3. **Policy evaluation error**: Ensure OPA is installed (`asdf install opa`) and the policy file is valid.

For further assistance, run the policy test with verbose output:

```bash
OPA_LOG_LEVEL=debug make pr-opa-policy-test
```