# Contributing to Terraform Modules

Thank you for your interest in contributing to our Terraform Modules repository! This document provides guidelines and instructions for contributing to this project.

## How to Contribute

### For External Contributors

If you're an external contributor (not a Caylent employee), please follow the standard open source fork and pull request workflow:

1. **Fork the Repository**:
   - Fork the repository to your GitHub account.
   - Clone your fork locally: `git clone https://github.com/YOUR-USERNAME/terraform-modules.git`

2. **Create a Branch**:
   - Create a branch for your changes: `git checkout -b feature/your-feature-name`

3. **Make Your Changes**:
   - Follow the [module structure requirements](docs/terraform-module-structure.md)
   - Ensure your module adheres to all [module policies](docs/terraform-module-policies.md)
   - Write tests for your module following the required test structure

4. **Validate Your Changes**:
   - Run validation on your module: `make module-validate MODULE_PATH=your/module/path MODULE_TYPE=<module_type>`
   - Ensure all tests pass: `cd your/module/path && make test`

5. **Commit Your Changes**:
   - Use conventional commit messages:
     - `feat:` for new features or modules
     - `fix:` for bug fixes
     - `docs:` for documentation changes
     - `test:` for test changes
     - `refactor:` for code refactoring
   - Example: `feat: add aws s3 bucket primitive module`

6. **Submit a Pull Request**:
   - Go to the original repository and create a pull request from your branch.
   - Provide a clear description of your module or changes.
   - Reference any related issues.

7. **Review Process**:
   - Maintainers will review your PR and may request changes.
   - Once approved, your PR will be merged.

### For Caylent Contributors

If you're a Caylent employee, please follow the internal development workflow:

1. **Clone the Repository**:
   - Clone the repository directly: `git clone https://github.com/caylent-solutions/terraform-modules.git`

2. **Create a Branch**:
   - Create a feature branch: `git checkout -b feature/your-module-name`

3. **Create Your Module**:
   - Start from the skeleton: `cp -r skeletons/generic-skeleton providers/aws/primitives/your-module-name`
   - Follow the [module structure requirements](docs/terraform-module-structure.md)
   - Implement your module functionality
   - Create examples and tests

4. **Validate Your Module**:
   - Run validation: `make module-validate MODULE_PATH=providers/aws/primitives/your-module-name MODULE_TYPE=primitive`
   - Run tests: `cd providers/aws/primitives/your-module-name && make test`

5. **Create a Pull Request**:
   - Push your changes and create a PR to the main branch
   - Get it reviewed by at least one team member
   - Address any feedback

6. **Merge Your PR**:
   - Once approved, merge your PR to the main branch
   - Delete your feature branch after merging

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

## Pull Request Process

When you submit a pull request:
1. Automated checks will validate your module against all policies
2. Code owners will be automatically notified for review
3. All checks must pass and reviews must be approved before merging

## Getting Help

If you have questions or need help, please:
- Open an issue in the repository
- Refer to the documentation in the docs directory
- Contact the repository maintainers

Thank you for contributing to our Terraform Modules repository!