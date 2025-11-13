# Basic Example

This directory contains a basic example of how to use this Terraform module.

## Usage

```hcl
module "example" {
  source = "../../"
  
  example_variable = "example-value"
}
```

## Requirements

- Terraform >= 1.0.0
- AWS provider >= 4.0.0

## Inputs

Refer to [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for all inputs and outputs.

## Testing

This example is tested as part of the module's test suite. To run tests specifically for this example:

```bash
cd ../../
make test-basic
```