# Terraform Modules Documentation

This directory contains documentation for the Terraform Modules repository.

## Module Development

- [Terraform Module Structure](terraform-module-structure.md) - Required structure for all modules
- [Terraform Module Policies](terraform-module-policies.md) - Policies enforced for all modules
- [Terraform Module Testing](terraform-module-testing.md) - Testing requirements and framework
- [Module Validation](module-validation.md) - How modules are validated against policies
- [Monorepo Configuration](monorepo-config.md) - Configuration for the monorepo automation

## Repository Policies

- [Terraform Module PR Policy](policies/terraform-module-pr.md) - Policy for PRs that modify modules
- [Monorepo Code PR Policy](policies/monorepo-code-pr.md) - Policy for PRs that modify non-module files
- [Empty PR Policy](policies/empty-pr.md) - Policy requiring PRs to contain changes

## Scripts

- [PR OPA Policy Test Script](scripts/pr-opa-policy-test.md) - Script for testing PRs against policies

## Contributing

For information on how to contribute to this repository, see the [Contributing Guidelines](../CONTRIBUTING.md) in the repository root.