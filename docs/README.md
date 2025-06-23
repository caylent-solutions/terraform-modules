# Terraform Modules Documentation

This directory contains documentation for the Terraform Modules repository.

## Security

- [GitHub Actions Security Scripts](../security-scripts/README.md) - Tools for maintaining secure GitHub Actions

## Workflow and Process

- [Complete Workflow Logic](WORKFLOW_LOGIC.md) - Detailed flow of all CI/CD workflows
- [Main Validation SDLC Guide](main-validation-sdlc.md) - SDLC process for workflow maintenance
- [Contributor Guide](../CONTRIBUTOR_GUIDE.md) - Complete SDLC process for contributors
- [Contributing Guidelines](../CONTRIBUTING.md) - How to contribute to this repository

## Module Development

- [Terraform Module Structure](terraform-module-structure.md) - Required structure for all modules
- [Terraform Module Policies](terraform-module-policies.md) - Policies enforced for all modules
- [Terraform Module Testing](terraform-module-testing.md) - Testing requirements and framework
- [Module Validation](module-validation.md) - How modules are validated against policies
- [Monorepo Configuration](monorepo-config.md) - Configuration for the monorepo automation

## Repository Policies

- [Terraform Module PR Policy](policies/terraform-module-pr.md) - Policy for PRs that modify modules
- [Monorepo Code PR Policy](policies/monorepo-code-pr.md) - Policy ensuring PRs either modify one module OR only non-module files
- [Empty PR Policy](policies/empty-pr.md) - Policy requiring PRs to contain changes

## Scripts

- [Scripts Documentation Index](scripts/README.md) - Index of all script documentation
- [Detect Proposed Git Repo Changes](scripts/detect-proposed-git-repo-changes.md) - Detects and validates PR changes
- [Go Unit Test](scripts/go-unit-test.md) - Runs Go unit tests and collects coverage metrics
- [Install Tools](scripts/install-tools.md) - Installs and manages development tools
- [Go Format](scripts/go-format.md) - Automatically formats Go code according to standard formatting rules
- [Go Lint](scripts/go-lint.md) - Performs code quality checks on Go code
- [Module Type Validator](scripts/module-type-validator.md) - Detects module type based on path
- [Module Validator](scripts/module-validator.md) - Validates modules against type-specific policies
- [Rego Unit Test](scripts/rego-unit-test.md) - Runs OPA/Rego unit tests and collects coverage metrics
- [Terraform File Collector](scripts/terraform-file-collector.md) - Collects Terraform files for policy evaluation

## Contributing

For information on how to contribute to this repository, see the [Contributing Guidelines](../CONTRIBUTING.md) in the repository root.