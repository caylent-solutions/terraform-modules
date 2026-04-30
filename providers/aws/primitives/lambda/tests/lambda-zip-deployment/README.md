# Lambda Zip Deployment Tests

## Overview

Zip deployment tests validate features specific to Lambda functions deployed using Zip packages stored in S3. These tests cover S3 deployment, event sources, function URLs, aliases, and advanced configurations.

## Test Strategy

All tests run in a single provision cycle for efficiency.

### Process Flow

1. **Provision Once**: Deploy `lambda-zip-deployment` example infrastructure (S3, Lambda, SQS, SNS, etc.)
2. **Run All Subtests**: Execute all 7 test scenarios as Go subtests
3. **Idempotency Test**: Framework automatically validates terraform plan shows no changes
4. **Destroy Once**: Tear down all infrastructure

## Test Suite: TestZipDeploymentFeatures

Single test function that provisions infrastructure once and runs all subtests.

### Subtests

#### 1. ZipPackageDeployment
**Purpose**: Validates basic Zip package deployment

**Validates**:
- `function_arn` - Function ARN exists
- ARN format is valid Lambda ARN

**Why It Matters**: Confirms core deployment method works

---

#### 2. EventSourceMapping
**Purpose**: Validates SQS event source integration

**Validates**:
- `event_source_mapping_uuid` - Mapping UUID exists
- `event_source_mapping_state` - State is valid (Enabled/Enabling/Creating)

**Why It Matters**: Ensures Lambda can consume events from SQS queues

---

#### 3. S3DeploymentMethod
**Purpose**: Validates S3-based deployment package storage

**Validates**:
- `s3_bucket` - S3 bucket name exists
- `s3_key` - S3 object key exists and contains "function-" prefix

**Why It Matters**: Confirms deployment package is properly stored in S3 for packages >50MB

---

#### 4. FunctionUrl
**Purpose**: Validates Lambda Function URL

**Validates**:
- `function_url` - URL exists
- URL uses HTTPS protocol
- URL contains `.lambda-url.` domain

**Why It Matters**: Confirms direct HTTP(S) invocation endpoint works

---

#### 5. Alias
**Purpose**: Validates Lambda alias configuration

**Validates**:
- `alias_arn` - Alias ARN exists
- ARN contains `:prod` alias name

**Why It Matters**: Enables blue/green deployments and traffic shifting

---

#### 6. ProvisionedConcurrency
**Purpose**: Validates provisioned concurrency configuration

**Validates**:
- `provisioned_concurrency_id` - Configuration ID exists

**Why It Matters**: Ensures cold start mitigation is configured

---

#### 7. PublishedVersion
**Purpose**: Validates Lambda version publishing

**Validates**:
- `function_version` - Version number exists
- Version is numeric (can be parsed as integer)

**Why It Matters**: Confirms versioning works for blue/green deployments and rollbacks

---

## Running Tests

### Run All Tests (CI)
```bash
cd /workspaces/terraform-modules/providers/aws/primitives/lambda
set -a && source test.config && set +a
go test -v -timeout ${GO_TEST_TIMEOUT} ./tests/...
```

### Run Zip Tests Only (Local Dev)
```bash
go test -v -timeout ${GO_TEST_TIMEOUT} -run TestZipDeploymentFeatures ./tests/lambda-zip-deployment/
```

### Run Specific Subtest (Local Dev)
```bash
go test -v -run TestZipDeploymentFeatures/FunctionUrl ./tests/lambda-zip-deployment/
```

### Expected Output
```
=== RUN   TestZipDeploymentFeatures
=== RUN   TestZipDeploymentFeatures/ZipPackageDeployment
=== RUN   TestZipDeploymentFeatures/EventSourceMapping
=== RUN   TestZipDeploymentFeatures/S3DeploymentMethod
=== RUN   TestZipDeploymentFeatures/FunctionUrl
=== RUN   TestZipDeploymentFeatures/Alias
=== RUN   TestZipDeploymentFeatures/ProvisionedConcurrency
=== RUN   TestZipDeploymentFeatures/PublishedVersion
--- PASS: TestZipDeploymentFeatures (240.00s)
    --- PASS: TestZipDeploymentFeatures/ZipPackageDeployment (0.01s)
    --- PASS: TestZipDeploymentFeatures/EventSourceMapping (0.01s)
    --- PASS: TestZipDeploymentFeatures/S3DeploymentMethod (0.01s)
    --- PASS: TestZipDeploymentFeatures/FunctionUrl (0.01s)
    --- PASS: TestZipDeploymentFeatures/Alias (0.01s)
    --- PASS: TestZipDeploymentFeatures/ProvisionedConcurrency (0.01s)
    --- PASS: TestZipDeploymentFeatures/PublishedVersion (0.01s)
PASS
```

## Test Configuration

- **Idempotency**: Enabled
- **Global Timeout**: 60 minutes (configured in `test.config`)
- **Example Used**: `lambda-zip-deployment`
- **Execution Time**: ~2.5 minutes (local), may be slower in CI

## Infrastructure Created

The test provisions:
- S3 bucket for deployment packages
- Lambda function with Zip deployment
- SQS queue and DLQ
- SNS topics for success/failure
- KMS key for encryption
- CloudWatch log group
- Function URL
- Lambda alias (prod)
- Provisioned concurrency
- Event source mapping
- SSM Parameter and Secrets Manager secret (with random suffix)

## Architecture

```
TestZipDeploymentFeatures (main test)
├── Provision infrastructure (once)
│   ├── S3 bucket + object
│   ├── Lambda function
│   ├── SQS queues
│   ├── SNS topics
│   ├── KMS key
│   └── Supporting resources
├── ZipPackageDeployment (subtest)
├── EventSourceMapping (subtest)
├── S3DeploymentMethod (subtest)
├── FunctionUrl (subtest)
├── Alias (subtest)
├── ProvisionedConcurrency (subtest)
├── PublishedVersion (subtest)
├── Idempotency validation (automatic)
└── Destroy infrastructure (once)
```

## Key Benefits

1. **Efficient**: Single provision cycle for all tests
2. **Comprehensive**: Tests all Zip-specific features
3. **Reliable**: Shared infrastructure ensures consistent test environment
4. **Maintainable**: Each subtest is independent and focused
5. **Debuggable**: Can run individual subtests for troubleshooting
6. **CI/CD Ready**: Fast execution suitable for automated pipelines

## Important Notes

### Resource Naming
- All resources use random suffix to prevent collisions across test runs
- Example: `test-lambda-zip-a5d3f491`

### Secrets Manager
- Secrets use `recovery_window_in_days = 0` for immediate deletion
- Prevents "secret scheduled for deletion" errors on re-runs

### Concurrency Limits
- `maximum_concurrency = 5` (must be <= `reserved_concurrent_executions = 5`)
- AWS enforces this constraint

### Environment Variables
- All env vars must be strings (Secrets Manager values are NOT decoded)
- Module uses `secret_string` directly, not `jsondecode()`

## Troubleshooting

### Test Timeout
Global timeout is configured in `test.config` (60 minutes for all tests combined)

### Resource Cleanup
If test fails, manually destroy:
```bash
cd examples/lambda-zip-deployment
terraform destroy -auto-approve
```

### Subtest Failure
Run specific subtest to isolate issue:
```bash
go test -v -run TestZipDeploymentFeatures/FailingSubtest ./tests/lambda-zip-deployment/
```

## Framework Details

- Uses `testctx.RunSingleExample()` from terraform-terratest-framework v1.3.0
- All subtests share the same `ctx` (TestContext) instance
- Failed subtests don't block other subtests from running
- Framework handles all Terraform lifecycle (init, apply, plan, destroy)
- Automatic idempotency validation via `TERRATEST_IDEMPOTENCY=true`
