# Lambda Docker Deployment Tests

## Overview

Docker deployment tests validate features specific to Lambda functions deployed using container images from ECR. These tests cover ECR integration, VPC configuration, EFS mounts, ARM64 architecture, and Lambda extensions.

## Test Strategy

All tests run in a single provision cycle for efficiency.

### Process Flow

1. **Provision Once**: Deploy `lambda-docker-deployment` example infrastructure (ECR, Docker build/push, VPC, EFS, Lambda)
2. **Run All Subtests**: Execute all 9 test scenarios as Go subtests
3. **Idempotency Test**: Disabled (VPC ENI cleanup is slow)
4. **Destroy Once**: Tear down all infrastructure

⚠️ **Warning**: Docker tests take 28+ minutes due to VPC, EFS, and Docker image build. Recommended for manual testing only.

## Test Suite: TestDockerDeploymentFeatures

Single test function that provisions infrastructure once and runs all subtests.

### Subtests

#### 1. DockerImageDeployment
**Purpose**: Validates container image deployment from ECR

**Validates**:
- `function_arn` - Function ARN exists
- ARN format is valid Lambda ARN

**Why It Matters**: Confirms core Docker deployment method works

---

#### 2. ECRRepository
**Purpose**: Validates ECR repository creation and image storage

**Validates**:
- `ecr_repository_url` - Repository URL exists
- URL contains `.dkr.ecr.` domain

**Why It Matters**: Ensures container images are properly stored in ECR

---

#### 3. ImageConfig
**Purpose**: Validates container image configuration

**Validates**:
- Function is created with image config
- Command override is applied (`app.handler`)

**Why It Matters**: Ensures container entrypoint is correctly configured

---

#### 4. VPCConfiguration
**Purpose**: Validates VPC integration

**Validates**:
- Function is deployed in VPC
- Security groups and subnets are attached

**Why It Matters**: Enables private resource access (RDS, ElastiCache, etc.)

---

#### 5. EFSConfiguration
**Purpose**: Validates EFS file system mount

**Validates**:
- `efs_file_system_id` - EFS ID exists
- ID format is valid (`fs-` prefix)

**Why It Matters**: Enables stateful workloads and shared storage

---

#### 6. LayerVersion
**Purpose**: Validates custom Lambda layer

**Validates**:
- `layer_version_arn` - Layer ARN exists
- ARN format is valid Lambda layer ARN

**Why It Matters**: Confirms layers work with container deployments

---

#### 7. ParametersAndSecretsExtension
**Purpose**: Validates Lambda Extension for runtime parameter/secret access

**Validates**:
- Function is created with extension enabled
- Extension config is applied (port, timeouts, max connections)

**Why It Matters**: Enables runtime access to SSM/Secrets without environment variables

---

#### 8. ArchitectureArm64
**Purpose**: Validates ARM64 (Graviton2) architecture

**Validates**:
- Function is deployed with ARM64 architecture
- Image is built for ARM64

**Why It Matters**: Confirms cost-optimized ARM architecture support

---

#### 9. UnreservedConcurrency
**Purpose**: Validates unreserved concurrency (-1 = unlimited)

**Validates**:
- Function has no concurrency limits
- Can scale to account limits

**Why It Matters**: Ensures function can scale without artificial limits

---

## Running Tests

### Run All Tests (CI)
```bash
cd /workspaces/terraform-modules/providers/aws/primitives/lambda
set -a && source test.config && set +a
go test -v -timeout ${GO_TEST_TIMEOUT} ./tests/...
```

### Run Docker Tests Only (Local Dev)
```bash
go test -v -timeout ${GO_TEST_TIMEOUT} -run TestDockerDeploymentFeatures ./tests/lambda-docker-deployment/
```

### Run Specific Subtest (Local Dev)
```bash
go test -v -run TestDockerDeploymentFeatures/VPCConfiguration ./tests/lambda-docker-deployment/
```

### Expected Output
```
=== RUN   TestDockerDeploymentFeatures
=== RUN   TestDockerDeploymentFeatures/DockerImageDeployment
=== RUN   TestDockerDeploymentFeatures/ECRRepository
=== RUN   TestDockerDeploymentFeatures/ImageConfig
=== RUN   TestDockerDeploymentFeatures/VPCConfiguration
=== RUN   TestDockerDeploymentFeatures/EFSConfiguration
=== RUN   TestDockerDeploymentFeatures/LayerVersion
=== RUN   TestDockerDeploymentFeatures/ParametersAndSecretsExtension
=== RUN   TestDockerDeploymentFeatures/ArchitectureArm64
=== RUN   TestDockerDeploymentFeatures/UnreservedConcurrency
--- PASS: TestDockerDeploymentFeatures (1800.00s)
    --- PASS: TestDockerDeploymentFeatures/DockerImageDeployment (0.01s)
    --- PASS: TestDockerDeploymentFeatures/ECRRepository (0.01s)
    --- PASS: TestDockerDeploymentFeatures/ImageConfig (0.01s)
    --- PASS: TestDockerDeploymentFeatures/VPCConfiguration (0.01s)
    --- PASS: TestDockerDeploymentFeatures/EFSConfiguration (0.01s)
    --- PASS: TestDockerDeploymentFeatures/LayerVersion (0.01s)
    --- PASS: TestDockerDeploymentFeatures/ParametersAndSecretsExtension (0.01s)
    --- PASS: TestDockerDeploymentFeatures/ArchitectureArm64 (0.01s)
    --- PASS: TestDockerDeploymentFeatures/UnreservedConcurrency (0.01s)
PASS
```

## Test Configuration

- **Idempotency**: Disabled
- **Global Timeout**: 60 minutes (configured in `test.config`)
- **Example Used**: `lambda-docker-deployment`
- **Total Execution Time**: ~28 minutes (local), may be slower in CI (includes provision, test, and destroy)

## Infrastructure Created

The test provisions:
- ECR repository
- Docker image (built and pushed automatically via null_resource)
- Lambda function with container deployment
- VPC with 2 subnets across AZs
- Security group for Lambda
- EFS file system with mount targets and access point
- Custom Lambda layer
- SSM Parameter and Secrets Manager secret (with random suffix)
- IAM role with VPC and extension permissions

## Architecture

```
TestDockerDeploymentFeatures (main test)
├── Provision infrastructure (once)
│   ├── ECR repository
│   ├── Docker build + push (null_resource)
│   ├── VPC + subnets + security group
│   ├── EFS + mount targets + access point
│   ├── Lambda function (container)
│   └── Supporting resources
├── DockerImageDeployment (subtest)
├── ECRRepository (subtest)
├── ImageConfig (subtest)
├── VPCConfiguration (subtest)
├── EFSConfiguration (subtest)
├── LayerVersion (subtest)
├── ParametersAndSecretsExtension (subtest)
├── ArchitectureArm64 (subtest)
├── UnreservedConcurrency (subtest)
└── Destroy infrastructure (once)
```

## Key Benefits

1. **Efficient**: Single provision cycle for all tests
2. **Comprehensive**: Tests all Docker-specific features
3. **Automated**: Docker image build/push handled by Terraform
4. **Reliable**: Shared infrastructure ensures consistent test environment
5. **Maintainable**: Each subtest is independent and focused
6. **Debuggable**: Can run individual subtests for troubleshooting

## Important Notes

### Docker Image Build
- Image is automatically built from AWS Lambda Python 3.12 base image
- Built and pushed to ECR via `null_resource` with `local-exec` provisioner
- No manual Docker commands required

### Code Signing
- **NOT SUPPORTED** for container images
- Code signing configuration is commented out in example
- AWS limitation, not module limitation

### VPC ENI Cleanup
- Lambda-managed ENIs are automatically cleaned up by AWS
- Cannot be manually deleted (AWS managed)
- Framework handles cleanup automatically

### Resource Naming
- All resources use random suffix to prevent collisions
- Example: `test-lambda-docker-a5d3f491`

### Idempotency
- Disabled due to Docker build timestamp trigger
- VPC ENI cleanup makes re-runs impractical
- Tests are validated but not idempotent



## Troubleshooting

### Test Timeout
Global timeout is configured in `test.config` (60 minutes for all tests combined)

### Resource Cleanup
If test fails, manually destroy:
```bash
cd examples/lambda-docker-deployment
terraform destroy -auto-approve
```

### Docker Build Failure
Check Docker daemon is running:
```bash
docker ps
```

Manually build and push:
```bash
cd examples/lambda-docker-deployment
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin <account>.dkr.ecr.us-east-2.amazonaws.com
docker build -t test-lambda-docker .
docker tag test-lambda-docker:latest <account>.dkr.ecr.us-east-2.amazonaws.com/test-lambda-docker:latest
docker push <account>.dkr.ecr.us-east-2.amazonaws.com/test-lambda-docker:latest
```

### Subtest Failure
Run specific subtest to isolate issue:
```bash
go test -v -timeout 60m -run TestDockerDeploymentFeatures/FailingSubtest ./tests/lambda-docker-deployment/
```

## CI/CD Recommendations

**Note**: Docker tests take ~28 minutes due to VPC, EFS, and Docker image build.

**Recommended Usage**:
- Run in CI/CD as part of full test suite
- Run manually for Docker-specific changes
- Use Zip tests for faster feedback during development

## Framework Details

- Uses `testctx.RunSingleExample()` from terraform-terratest-framework v1.3.0
- All subtests share the same `ctx` (TestContext) instance
- Failed subtests don't block other subtests from running
- Framework handles all Terraform lifecycle (init, apply, destroy)
- Idempotency disabled via `TERRATEST_IDEMPOTENCY=false` (set per-test if needed)

## Removed Tests

### TestCodeSigningConfig
**Removed**: Code signing is not supported for container images (AWS limitation)

**Error**: `InvalidParameterValueException: Code signing is not supported for functions created with container images`

**Workaround**: None - use Zip deployment if code signing is required
