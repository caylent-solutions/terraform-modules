# Scripts Documentation

This directory contains documentation for the various scripts used in the Terraform modules monorepo. These scripts automate common tasks, enforce governance policies, and validate modules against established standards.

## Available Scripts

| Script | Description |
|--------|-------------|
| [Detect Proposed Git Repo Changes](detect-proposed-git-repo-changes.md) | Detects and validates changes in pull requests to enforce the single module policy and separation policy |
| [Go Format](go-format.md) | Automatically formats Go code in the repository according to Go's standard formatting rules |
| [Go Unit Test](go-unit-test.md) | Runs Go unit tests and collects coverage metrics for Go code in the monorepo |
| [Install Tools](install-tools.md) | Installs and manages development tools using ASDF version manager |
| [Go Lint](go-lint.md) | Performs code quality checks on Go code using gofmt and go vet |
| [Module Type Validator](module-type-validator.md) | Detects the type of a Terraform module based on its path |
| [Module Validator](module-validator.md) | Validates Terraform modules against type-specific policies |
| [PR OPA Policy Test](pr-opa-policy-test.md) | Evaluates pull requests against Open Policy Agent (OPA) policies |
| [Rego Unit Test](rego-unit-test.md) | Runs unit tests for OPA Rego policies and generates coverage reports |
| [Terraform File Collector](terraform-file-collector.md) | Collects and processes Terraform files for policy evaluation |

## Usage

Most of these scripts are used automatically by the CI/CD pipeline or through make tasks. For example:

```bash
# Install required tools
make install-tools

# Format Go code
make go-format

# Run Go unit tests with coverage
make go-unit-test-coverage

# Run Rego unit tests with coverage
make rego-unit-test-coverage

# Validate a module
make module-validate MODULE_PATH=providers/aws/primitives/s3-bucket MODULE_TYPE=primitive
```

See each script's documentation for detailed usage instructions and examples.

## Integration with CI/CD

These scripts form the backbone of the monorepo's CI/CD pipeline:

1. When a PR is submitted, the `pr-validation.yml` workflow runs
2. The `detect-proposed-git-repo-changes` script determines what type of changes are in the PR
3. For module changes:
   - The `module-type-validator` script determines the module type
   - The `module-validator` script validates the module against type-specific policies
4. For non-module changes (via `non-terraform-validation.yml`):
   - The `go-format` script ensures Go code is properly formatted
   - The `lint` script checks Go code quality
   - The `go-unit-test` script runs Go tests and checks coverage
   - The `rego-lint` script checks Rego code quality
   - The `rego-format` script ensures Rego code is properly formatted
   - The `rego-unit-test` script runs OPA policy tests and checks coverage

This ensures that all changes adhere to the monorepo's governance policies and quality standards.