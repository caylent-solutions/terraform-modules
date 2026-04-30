# Basic SQS Queue Tests

This directory contains tests specific to the basic example of the `sqs-queue` module.

## Tests Included

- **TestBasicQueueCreation**: Verifies the main SQS queue is created with correct ARN format and non-empty outputs.
- **TestBasicDLQCreation**: Verifies the dead-letter queue is created when `enable_dlq = true`.
- **TestBasicDLQAlarmCreation**: Verifies the CloudWatch alarm for DLQ depth is created when `enable_dlq_alarm = true`.
- **TestBasicResourceCounts**: Validates the exact number of SQS queues and CloudWatch alarms created.
- **TestIdempotency**: Confirms the module is idempotent via the Terratest framework assertion.
- **TestRequiredOutputs**: Confirms all expected outputs are non-empty.

## Running Tests

```bash
# Run all tests for this module
make test

# Run tests directly with Go
go test ./tests/basic -v -timeout 30m
```

## Test Requirements

- Go >= 1.24
- Terraform >= 1.12.1
- AWS credentials configured
- All test files must pass linting (`make go-lint`) and formatting (`make go-format`)
