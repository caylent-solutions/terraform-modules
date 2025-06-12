# PR OPA Policy Test Script

## Purpose and Scope

The `pr-opa-policy-test` script is a Go utility that evaluates Pull Request (PR) changes against Open Policy Agent (OPA) policies defined in the repository. It helps enforce governance rules for the Terraform monorepo by validating that PRs follow the established patterns for module and non-module changes.

## Integration with Repository

This script is located at `scripts/pr-opa-policy-test/main.go` and is executed via the `make pr-opa-policy-test` command. It requires two parameters:

- `--config`: Path to the monorepo configuration file
- `--policy-dir`: Directory containing the OPA policy files

The script reads configuration from the specified file and evaluates the policies in the specified directory.

## Example Usage

### Local Testing

To test your changes locally before submitting a PR:

1. Update the test changed files in the configuration:

```json
// monorepo-config.json
{
  "module_roots": [...],
  "test_changed_files": [
    "providers/aws/collections/my-module/main.tf",
    "providers/aws/collections/my-module/variables.tf"
  ]
}
```

2. Run the policy test:

```bash
make pr-opa-policy-test
```

Or run the script directly with explicit parameters:

```bash
go run ./scripts/pr-opa-policy-test/main.go --config ./monorepo-config.json --policy-dir ./policies/opa/global
```

### CI/CD Integration

In CI/CD pipelines, the script is automatically run as part of the PR validation workflow:

```yaml
# .github/workflows/pr-validation.yml
steps:
  - name: Get changed files
    run: |
      # Update the config file with actual changed files
      jq --argjson files "$CHANGED_FILES" '.test_changed_files = $files' monorepo-config.json > monorepo-config.json.tmp
      mv monorepo-config.json.tmp monorepo-config.json

  - name: Run monorepo policy check
    run: make pr-opa-policy-test
```

## Edge Case Behavior

- **Missing input flags**: The script will exit with an error if either the `--config` or `--policy-dir` flags are not provided.
- **Invalid config file**: The script will exit with an error if the config file cannot be read or parsed.
- **No policy files**: If no policy files are found in the specified directory, the script will exit successfully with a warning.
- **Invalid policy files**: If a policy file cannot be evaluated, the script will report an error.
- **Git errors**: If git commands fail (e.g., in a shallow clone), the script will use the test_changed_files from the configuration.

## Troubleshooting

Common issues and solutions:

1. **OPA not installed**: Ensure OPA is installed via ASDF (`asdf install opa`).
2. **Invalid configuration**: Check that the config file is valid JSON and contains the required fields.
3. **Policy evaluation errors**: Run with debug logging to see detailed OPA evaluation:

```bash
OPA_LOG_LEVEL=debug make pr-opa-policy-test
```

4. **Git issues**: If git commands fail, you can manually specify changed files in the configuration file.