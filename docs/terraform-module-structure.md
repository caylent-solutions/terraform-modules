# Terraform Module Structure Requirements

This document outlines the required structure and files for all Terraform modules in this repository.

## Directory Structure

All Terraform modules must follow this structure:

```
terraform-module/
├── examples/                # Example implementations of the module
│   └── example-name/        # At least one example implementation
│       ├── main.tf         
│       ├── variables.tf    
│       ├── versions.tf     
│       ├── terraform.tfvars
│       ├── README.md       
│       └── TERRAFORM-DOCS.md
├── tests/                   # Tests for the module
│   ├── example-name/        # Tests for each example (same name as example)
│   │   ├── module_test.go  
│   │   └── README.md       
│   ├── common/              # Common tests (required if multiple examples)
│   │   ├── module_test.go  
│   │   └── README.md       
│   └── README.md            # Tests documentation
├── main.tf                  # Main module code
├── variables.tf             # Input variables
├── outputs.tf               # Output values (can be empty)
├── versions.tf              # Required providers and versions
├── locals.tf                # Local variables (can be empty)
├── README.md                # Module documentation
├── TERRAFORM-DOCS.md        # Generated Terraform documentation
├── CODEOWNERS               # File ownership information
├── Makefile                 # Automation for common tasks
└── test.config              # Test configuration settings
```

## File Requirements

### Root Directory Files

| File | Required | Can be Empty | Description |
|------|----------|-------------|-------------|
| main.tf | Yes | No | Main module code |
| variables.tf | Yes | No | Input variables |
| outputs.tf | Yes | Yes | Output values |
| versions.tf | Yes | No | Required providers and versions |
| locals.tf | Yes | Yes | Local variables |
| README.md | Yes | No | Module documentation |
| TERRAFORM-DOCS.md | Yes | No | Generated Terraform documentation |
| CODEOWNERS | Yes | No | File ownership information |
| Makefile | Yes | No | Must match the skeleton Makefile |
| test.config | Yes | No | Test configuration with TERRATEST_IDEMPOTENCY setting |

### Example Directory Files

Each example directory must contain:

| File | Required | Can be Empty | Description |
|------|----------|-------------|-------------|
| main.tf | Yes | No | Example implementation |
| variables.tf | Yes | No | Example variables |
| versions.tf | Yes | No | Example provider versions |
| terraform.tfvars | Yes | No | Example variable values |
| README.md | Yes | No | Example documentation |
| TERRAFORM-DOCS.md | Yes | No | Generated example documentation |

### Tests Directory Structure

The tests directory must contain:

1. A README.md file
2. For each directory under `examples/`, there must be a corresponding directory with the same name under `tests/`
3. If there are multiple example directories, a `common/` directory is also required under `tests/`
4. Each test directory must contain:
   - module_test.go
   - README.md



## Test Configuration

The `test.config` file must contain:

```bash
# Test configuration for this module
# This file controls test behavior settings

# Set to true or false to enable/disable idempotency testing
TERRATEST_IDEMPOTENCY=true

# Add other test configuration settings below
```

This file controls test behavior and is required for all modules. The TERRATEST_IDEMPOTENCY setting must be explicitly set to either true or false.

## Additional Requirements

1. **No nested modules**: Terraform modules cannot contain nested modules.
2. **Limited .tf files**: Only main.tf, variables.tf, outputs.tf, versions.tf, and locals.tf are allowed in the root directory.
3. **No hard-coded values**: All values in Terraform code must use variables instead of hard-coded values.
4. **Makefile content**: The Makefile must match the content of the skeleton Makefile.

## Creating a New Module

To create a new module that follows these requirements:

1. Copy the skeleton module:
   ```bash
   cp -r skeletons/generic-skeleton your-new-module
   ```

2. Modify the module files to implement your functionality.

3. Update the examples to demonstrate your module's usage.

4. Write tests to verify your module's functionality.

5. Configure test behavior in the test.config file.

6. Run validation to ensure your module meets all requirements:
   ```bash
   make module-validate MODULE_PATH=your-new-module MODULE_TYPE=<module_type>
   ```