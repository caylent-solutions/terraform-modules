# Empty PR Policy

## Purpose and Scope

This policy enforces that Pull Requests (PRs) must contain at least one file change. Empty PRs without any changes are rejected.

## Integration with Repository

This policy is implemented as a Rego file at `policies/opa/global/empty_pr_policy.rego` and is evaluated during PR validation.

The policy uses the configuration from the `monorepo-config.json` file.

## Edge Case Behavior

- **Merge commits**: PRs that only contain merge commits without file changes will be rejected.
- **Whitespace-only changes**: PRs with only whitespace changes will pass as long as at least one file is modified.

## Troubleshooting

If your PR fails this policy check:

1. **Empty PR**: Add meaningful changes to your PR or close it if created by mistake.
2. **False positive**: Ensure your PR actually contains file changes.
3. **Policy evaluation error**: Ensure OPA is installed (`asdf install opa`) and the policy file is valid.