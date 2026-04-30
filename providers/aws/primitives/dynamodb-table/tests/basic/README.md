# Basic DynamoDB Table Tests

This directory contains tests specific to the basic example, demonstrating
standard DynamoDB table creation with PAY_PER_REQUEST billing mode.

## Tests Included

- **TestBasicDynamoDBTableCreation**: Verifies the table is created with non-empty ARN, name, and ID
- **TestBasicDynamoDBTableARNFormat**: Verifies the table ARN matches the expected DynamoDB ARN pattern
- **TestBasicDynamoDBTableHashKey**: Verifies the hash key is configured as "pk"
- **TestBasicDynamoDBTableBillingMode**: Verifies billing mode is PAY_PER_REQUEST
- **TestBasicDynamoDBResourceCount**: Verifies exactly one DynamoDB table resource is created
- **TestBasicDynamoDBTableStreamDisabled**: Verifies stream ARN is empty when streams are disabled
- **TestBasicDynamoDBRequiredOutputs**: Verifies all required outputs are non-empty
- **TestBasicDynamoDBTerraformValidate**: Runs terraform validate on the example
- **TestBasicDynamoDBIdempotency**: Verifies the table configuration is idempotent
- **TestBasicDynamoDBStateContainsTable**: Verifies the table resource is in Terraform state

## Key Features Tested

- PAY_PER_REQUEST billing mode (on-demand capacity)
- Point-in-time recovery enabled by default
- Server-side encryption enabled (AWS-managed key when no KMS ARN provided)
- Stream disabled by default
- TTL disabled by default
- Correct ARN format: `arn:aws:dynamodb:<region>:<account>:table/<name>`

## Running Tests

```bash
# Run basic tests
cd ../../
make test

# Run with specific timeout
GO_TEST_TIMEOUT=30m make test
```

## Test Coverage

These tests verify:
- Table creation with correct configuration
- Correct ARN format for provisioned resources
- Hash key configuration
- Billing mode (PAY_PER_REQUEST)
- Resource count (exactly one table)
- Stream disabled by default
- Idempotency of table configuration
