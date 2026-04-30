# Common Lambda Tests

## Overview

Common tests validate features that are identical across all Lambda deployment methods (Zip and Docker). These tests run against the `lambda-zip-deployment` example to verify core Lambda functionality.

## Test Strategy

All tests run in a single provision cycle for efficiency.

### Process Flow

1. **Provision Once**: Deploy `lambda-zip-deployment` example infrastructure
2. **Run All Subtests**: Execute all 4 test scenarios as Go subtests
3. **Idempotency Test**: Framework automatically validates terraform plan shows no changes
4. **Destroy Once**: Tear down all infrastructure

## Test Suite: TestCommonFeatures

Single test function that provisions infrastructure once and runs all subtests.

### Subtests

#### 1. CommonOutputs
**Purpose**: Validates all required Terraform outputs are present and non-empty

**Validates**:
- `function_arn` - Lambda function ARN exists
- `function_invoke_arn` - Invocation ARN exists
- `function_version` - Version number exists

**Why It Matters**: Ensures module outputs are correctly exposed for downstream consumers

---

#### 2. FunctionConfiguration
**Purpose**: Validates basic function configuration

**Validates**:
- `function_name` - Function name is set and accessible

**Why It Matters**: Confirms function is created with correct naming

---

#### 3. TracingConfiguration
**Purpose**: Validates X-Ray tracing is properly configured

**Validates**:
- `tracing_mode` - X-Ray tracing mode equals "Active" as configured in the zip example

**Why It Matters**: Ensures observability features are enabled

---

#### 4. PublishBehavior
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

### Run Common Tests Only (Local Dev)
```bash
go test -v -timeout ${GO_TEST_TIMEOUT} -run TestCommonFeatures ./tests/common/
```

### Run Specific Subtest (Local Dev)
```bash
go test -v -run TestCommonFeatures/CommonOutputs ./tests/common/
```

### Expected Output
```
=== RUN   TestCommonFeatures
=== RUN   TestCommonFeatures/CommonOutputs
=== RUN   TestCommonFeatures/FunctionConfiguration
=== RUN   TestCommonFeatures/TracingConfiguration
=== RUN   TestCommonFeatures/PublishBehavior
--- PASS: TestCommonFeatures (240.00s)
    --- PASS: TestCommonFeatures/CommonOutputs (0.01s)
    --- PASS: TestCommonFeatures/FunctionConfiguration (0.01s)
    --- PASS: TestCommonFeatures/TracingConfiguration (0.01s)
    --- PASS: TestCommonFeatures/PublishBehavior (0.01s)
PASS
```

## Test Configuration

- **Idempotency**: Enabled
- **Global Timeout**: 60 minutes (configured in `test.config`)
- **Example Used**: `lambda-zip-deployment`
- **Execution Time**: ~3 minutes (local), may be slower in CI

## Architecture

```
TestCommonFeatures (main test)
├── Provision infrastructure (once)
├── CommonOutputs (subtest)
├── FunctionConfiguration (subtest)
├── TracingConfiguration (subtest)
├── PublishBehavior (subtest)
├── Idempotency validation (automatic)
└── Destroy infrastructure (once)
```

## Key Benefits

1. **Efficient**: Single provision cycle for all tests
2. **Reliable**: Shared infrastructure ensures consistent test environment
3. **Maintainable**: Each subtest is independent and focused
4. **Debuggable**: Can run individual subtests for troubleshooting
5. **CI/CD Ready**: Fast execution suitable for automated pipelines

## Notes

- Tests use `testctx.RunSingleExample()` from terraform-terratest-framework v1.3.0
- All subtests share the same `ctx` (TestContext) instance
- Failed subtests don't block other subtests from running
- Framework handles all Terraform lifecycle (init, apply, plan, destroy)
