# Terraform Module Skeleton

This repository contains a skeleton for creating new Terraform modules with built-in testing using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/README.md).

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.12.1
- [Go](https://golang.org/doc/install) >= 1.23
- [asdf](https://asdf-vm.com/) for version management

### Clone the Skeleton

To start a new module from this skeleton:

```bash
# Clone the skeleton to a new directory
git clone https://github.com/your-org/terraform-modules.git
cd terraform-modules
cp -r skeletons/generic-skeleton your-new-module

# Initialize the new module
cd your-new-module
rm -rf .git
git init
```

### Install Required Tools

This project uses asdf to manage tool versions:

```bash
# Install tools defined in .tool-versions
asdf install
asdf reshim
```

### Install Dependencies

Use the provided Makefile to install all dependencies:

```bash
# Install Go dependencies and the tftest CLI tool
make install
```

## Module Structure

```
terraform-module/
├── examples/                # Example implementations of the module
│   ├── basic/              # Basic example with minimal configuration
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── advanced/           # Advanced example with more complex configuration
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── tests/                   # Tests for the module
│   ├── common/              # Tests that run on all examples
│   │   ├── module_test.go
│   │   ├── input_validation_test.go
│   │   └── README.md
│   ├── helpers/             # Helper functions for tests
│   │   ├── helpers.go
│   │   └── README.md
│   ├── basic/               # Tests for the basic example
│   │   ├── module_test.go
│   │   └── README.md
│   └── advanced/            # Tests for the advanced example
│       ├── module_test.go
│       └── README.md
├── main.tf                  # Main module code
├── variables.tf             # Input variables
├── outputs.tf               # Output values
├── versions.tf              # Required providers and versions
└── Makefile                 # Automation for common tasks
```

## Writing Tests

### Using the TestCtx Package

The `testctx` package is the core of the Terraform Terratest Framework, providing the essential functionality for running and managing Terraform tests. It offers several key functions:

- **RunSingleExample**: Runs a specific example with the given configuration
  ```go
  ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
      Name: "basic-test",
  })
  ```

- **RunAllExamples**: Runs all examples in parallel
  ```go
  results := testctx.RunAllExamples(t, "../../examples", configs)
  ```

- **DiscoverAndRunAllTests**: Automatically discovers and runs all examples
  ```go
  testctx.DiscoverAndRunAllTests(t, "../../", func(t *testing.T, ctx testctx.TestContext) {
      // Common assertions for all examples
  })
  ```

For more detailed documentation on the testctx package, see the [TestCtx Package Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/TESTCTX_PACKAGE.md).

### Using Assertions

The framework provides a set of assertions in the `pkg/assertions` package that you can use to verify your Terraform module's behavior:

```go
import (
    "testing"

    "github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
    "github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
)

func TestExample(t *testing.T) {
    ctx := testctx.RunSingleExample(t, "../../examples", "example", testctx.TestConfig{
        Name: "example-test",
    })
    
    // Use assertions
    assertions.AssertOutputEquals(t, ctx, "instance_type", "t2.micro")
    assertions.AssertOutputContains(t, ctx, "bucket_name", "my-bucket")
    assertions.AssertOutputMapContainsKey(t, ctx, "tags", "Environment")
}
```

For a complete list of available assertions, see the [Assertions Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/ASSERTIONS.md).

### Common Tests

Common tests run on all examples and verify basic functionality:

- **Idempotency**: Automatically included by the framework - ensures that applying the same Terraform code multiple times produces the same result
- **Validation**: Verifies that the Terraform code is syntactically valid
- **Formatting**: Checks if the Terraform code is properly formatted
- **Required Outputs**: Ensures that all required outputs are defined
- **Input Validation**: Verifies that inputs from terraform.tfvars match the provisioned outputs

See the [Common Tests README](./tests/common/README.md) for more details on these tests and how to control idempotency testing.

### Example-Specific Tests

Each example has its own tests that verify specific functionality:

- **Basic Example**: Tests the basic functionality of the module
- **Advanced Example**: Tests more complex configurations and features

See the [Basic Tests README](./tests/basic/README.md) and [Advanced Tests README](./tests/advanced/README.md) for more details.

## Variable Management

Each example uses a consistent approach to variable management:

1. **variables.tf**: Defines variables with default values
2. **terraform.tfvars**: Sets actual values for the example
3. **main.tf**: References variables instead of hardcoded values

This approach:
- Makes examples more maintainable
- Allows for dynamic testing
- Follows Terraform best practices

## Running Tests

Tests can be run using the provided Makefile commands:

```bash
# Run all tests
make test

# Run tests for a specific example
make test-basic
make test-advanced

# Run only common tests
make test-common

# Run a specific test
go test ./tests/common -run '^TestInputsMatchProvisioned
```

For more information on the `tftest` CLI tool, see the [CLI Usage Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/CLI_USAGE.md).

## Developer Workflow

1. **Clone the skeleton**: Start by cloning this skeleton to a new directory
2. **Modify the module**: Update the module code to implement your functionality
3. **Update examples**: Modify the examples to demonstrate your module's usage
4. **Write tests**: Update the tests to verify your module's functionality
5. **Run tests**: Run the tests using `make test`
6. **Commit and push**: Commit your changes and push to your repository

## References

- [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/README.md)
- [TestCtx Package Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/TESTCTX_PACKAGE.md)
- [Assertions Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/ASSERTIONS.md)
- [Directory Structure Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/DIRECTORY_STRUCTURE.md)
- [Writing Tests Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/WRITING_TESTS.md)
- [CLI Usage Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/CLI_USAGE.md)

# Lint Go test files
make go-lint

# Format Go test files
make go-format

# Generate Terraform documentation
make tf-docs

# Check Terraform documentation
make tf-docs-check

# Check Terraform formatting
make tf-format

# Fix Terraform formatting
make tf-format-fix

# Lint Terraform files
make tf-lint

# Run Terraform plan
make tf-plan

# Run security checks
make tf-security

# Run Terraform tests
make tf-test

# Run all tests (comprehensive test suite)
make test-all

# Clean up temporary files
make clean
```

For more information on the `tftest` CLI tool, see the [CLI Usage Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/CLI_USAGE.md).

## Developer Workflow

1. **Clone the skeleton**: Start by cloning this skeleton to a new directory
2. **Modify the module**: Update the module code to implement your functionality
3. **Update examples**: Modify the examples to demonstrate your module's usage
4. **Write tests**: Update the tests to verify your module's functionality
5. **Run tests**: Run the tests using `make test`
6. **Commit and push**: Commit your changes and push to your repository

## References

- [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/README.md)
- [TestCtx Package Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/TESTCTX_PACKAGE.md)
- [Assertions Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/ASSERTIONS.md)
- [Directory Structure Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/DIRECTORY_STRUCTURE.md)
- [Writing Tests Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/WRITING_TESTS.md)
- [CLI Usage Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/CLI_USAGE.md)
