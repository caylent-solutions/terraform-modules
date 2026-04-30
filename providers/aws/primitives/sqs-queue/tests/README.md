# Module Tests

This directory contains the Terratest fixtures for the `sqs-queue`
primitive module, using the
[Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

- **basic/** -- Terratest for the `examples/basic/` example, asserting
  primary queue + DLQ + redrive policy + CloudWatch alarm shape.

## Running

```bash
# Run from the repo root (sources test.config for GO_TEST_TIMEOUT and
# TERRATEST_IDEMPOTENCY, then invokes tftest run inside the module).
make tf-test MODULE_PATH=providers/aws/primitives/sqs-queue

# Format / lint the Go test files
cd providers/aws/primitives/sqs-queue && make go-format
cd providers/aws/primitives/sqs-queue && make go-lint
```

## Test Requirements

- Go (version pinned in `<repo-root>/.tool-versions`)
- Terraform >= 1.12.1
- AWS credentials configured for the target test account
  (`aws sts get-caller-identity` resolves the account; tests create and
  destroy live resources)
