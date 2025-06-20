# Contributing to Terraform Modules

Thank you for your interest in contributing to our Terraform Modules repository! This document provides guidelines and instructions for contributing to this project.

## Contribution Workflow Overview

This repository uses an automated CI/CD pipeline that handles different contributor types:

- **Internal Contributors** (Caylent employees): Streamlined workflow with automatic test execution
- **External Contributors**: Fork-based workflow with manual approval for test execution

## How to Contribute

### For External Contributors

External contributors must use the fork and pull request workflow:

1. **Fork the Repository**:
   - Fork the repository to your GitHub account
   - Clone your fork locally: `git clone https://github.com/YOUR-USERNAME/terraform-modules.git`

2. **Create a Branch**:
   - Create a branch for your changes: `git checkout -b feature/your-feature-name`

3. **Make Your Changes**:
   - Follow the [module structure requirements](docs/terraform-module-structure.md)
   - Ensure your module adheres to all [module policies](docs/terraform-module-policies.md)
   - Write tests for your module following the required test structure

4. **Validate Your Changes Locally**:
   - Install tools: `make install-tools`
   - Run validation: `make module-validate MODULE_PATH=your/module/path MODULE_TYPE=<module_type>`
   - Test locally: `cd your/module/path && make test`

5. **Commit Your Changes**:
   - Use conventional commit messages:
     - `feat:` for new features or modules
     - `fix:` for bug fixes
     - `docs:` for documentation changes
     - `test:` for test changes
     - `refactor:` for code refactoring
   - Example: `feat: add aws s3 bucket primitive module`

6. **Submit a Pull Request**:
   - Create a pull request from your fork to the main repository
   - Provide a clear description of your module or changes
   - Reference any related issues

7. **Automated Review Process**:
   - **Security Scan**: CodeQL analysis runs automatically in parallel
   - **Validation**: Your code is validated against all policies
   - **Manual Approval Required**: A Caylent maintainer must approve test execution for security
   - **Test Execution**: After approval, comprehensive tests run automatically
   - **Code Review**: Maintainers review your changes
   - **Auto-Merge**: Once approved, the PR is automatically merged

### For Caylent Contributors (Internal)

Internal contributors have direct repository access with streamlined workflow:

1. **Clone the Repository**:
   - Clone directly: `git clone https://github.com/caylent-solutions/terraform-modules.git`

2. **Create a Branch**:
   - Create a feature branch: `git checkout -b feature/your-module-name`

3. **Create Your Module**:
   - Start from skeleton: `cp -r skeletons/generic-skeleton providers/aws/primitives/your-module-name`
   - Follow the [module structure requirements](docs/terraform-module-structure.md)
   - Implement your module functionality
   - Create examples and tests

4. **Validate Your Module**:
   - Run validation: `make module-validate MODULE_PATH=providers/aws/primitives/your-module-name MODULE_TYPE=primitive`
   - Run tests: `cd providers/aws/primitives/your-module-name && make test`

5. **Submit a Pull Request**:
   - Push your changes and create a PR to the main branch
   - Provide clear description and reference any issues

6. **Automated Workflow**:
   - **Security Scan**: CodeQL analysis runs automatically in parallel
   - **Validation**: Code validated against all policies
   - **Test Execution**: Tests run automatically (no manual approval needed)
   - **Slack Notification**: Team notified when ready for review
   - **Manual Approval**: Code owners approve the merge
   - **Auto-Merge**: PR automatically merged after approval

## Module Types and Structure

This repository contains different types of Terraform modules:

1. **Primitives**: Basic building blocks that manage a single AWS resource
2. **Collections**: Combinations of primitives that solve common use cases
3. **References**: Reference implementations for specific scenarios
4. **Utilities**: Helper modules for common tasks
5. **Skeletons**: Template modules for creating new modules

Each module type has specific requirements. See the [module structure documentation](docs/terraform-module-structure.md) for details.

## Development Guidelines

### Module Structure

All modules must follow the required structure:
- Required files in the root directory (main.tf, variables.tf, etc.)
- Examples directory with at least one example
- Tests directory with corresponding test directories for each example
- Documentation in README.md and TERRAFORM-DOCS.md

### Code Quality

- No hard-coded values in Terraform code
- Variables must be declared in variables.tf
- Outputs must be declared in outputs.tf
- Provider configurations must be in versions.tf
- Local variables must be in locals.tf

### Testing

- Write tests for all examples using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework)
- Ensure tests validate the module's core functionality
- Include common tests for validation, formatting, and outputs
- Create example-specific tests for unique features
- Follow the [test structure requirements](docs/terraform-module-testing.md)
- Configure test behavior using the `test.config` file in the module root
- Control idempotency testing with `TERRATEST_IDEMPOTENCY=true|false` in the config file
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

## Pull Request Process

When you submit a pull request:
1. Automated checks will validate your module against all policies
2. Code owners will be automatically notified for review
3. All checks must pass and reviews must be approved before merging

## Automated CI/CD Pipeline

### Pull Request Validation Flow

When you submit a pull request, the following automated process occurs:

1. **Initial Validation** (`pr-validation.yml`):
   - Detects if changes are Terraform modules or non-Terraform code
   - Routes to appropriate validation workflow

2. **For Terraform Module Changes** (`terraform-module-validation.yml`):
   - **Security Scanning**: CodeQL analysis runs in parallel with validation
   - **Module Validation**: Policies, linting, formatting, documentation, security checks
   - **Contributor Detection**: Automatically identifies internal vs external contributors
   - **Test Execution**:
     - **Internal Contributors**: Tests run immediately after validation
     - **External Contributors**: Tests require manual approval via GitHub Environment protection
   - **Approval Process**: Code owners receive Slack notifications and must approve merge
   - **Auto-Merge**: PR automatically merges after approval

3. **For Non-Terraform Changes** (`non-terraform-validation.yml`):
   - **Security Scanning**: CodeQL analysis runs in parallel
   - **Code Quality**: Go and Rego linting, formatting, unit tests
   - **Coverage Requirements**: Minimum 95% test coverage for Rego code
   - **Integration Tests**: End-to-end policy validation
   - **Auto-Merge**: PR automatically merges after code owner approval

4. **Post-Merge Process**:
   - **Re-validation**: All checks re-run on merged code
   - **QA Certification**: Manual approval required for release
   - **Automatic Release**: Semantic versioning and GitHub release creation

### Security Measures

- **External Contributor Protection**: Tests require explicit approval to prevent malicious code execution
- **Environment Isolation**: External contributor tests run in protected environments
- **Code Scanning**: All code scanned for security vulnerabilities before and after merge
- **Manual Gates**: Multiple approval points ensure code quality and security

## Getting Help

If you have questions or need help, please:
- Open an issue in the repository
- Refer to the documentation in the docs directory
- Contact the repository maintainers

Thank you for contributing to our Terraform Modules repository!