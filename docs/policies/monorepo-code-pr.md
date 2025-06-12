# Monorepo Code PR Policy

## Purpose and Scope

This policy enforces that Pull Requests (PRs) modifying **non-module files** (such as documentation, scripts, Makefile, etc.) are allowed **only if they do not touch any Terraform module folders**. This ensures that infrastructure code changes are kept separate from repository maintenance changes.

The policy specifically prevents:
- Mixed changes across modules and non-modules in the same PR

## Integration with Repository

This policy is implemented as a Rego file at `policies/opa/global/monorepo_code_policy.rego` and is evaluated during PR validation using the `make pr-opa-policy-test` command.

The policy uses the same configuration as the Terraform module policy via the `pr-policy-config.json` file, which defines the module root directories to monitor.

## Example Usage

To test your changes locally before submitting a PR:

```bash
# Update the test_changed_files in pr-policy-config.json to match your changes
# Then run:
make pr-opa-policy-test
```

In CI/CD pipelines, this policy is automatically evaluated against the actual changed files in the PR.

## Edge Case Behavior

- **All module files**: PRs that only change module files are allowed (but must follow the terraform-module-pr policy).
- **All non-module files**: PRs that only change non-module files are allowed.
- **Repository structure changes**: Changes that modify the repository structure (adding new provider directories, etc.) should be done in separate PRs from module changes.

## Troubleshooting

If your PR fails this policy check:

1. **Mixed module and non-module changes**: Split your changes into separate PRs - one for module changes and one for non-module changes.
2. **False positive**: Check if your module paths are correctly defined in `pr-policy-config.json`.
3. **Policy evaluation error**: Ensure OPA is installed (`asdf install opa`) and the policy file is valid.

For further assistance, run the policy test with verbose output:

```bash
OPA_LOG_LEVEL=debug make pr-opa-policy-test
```