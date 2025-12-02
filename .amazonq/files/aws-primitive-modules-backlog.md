# AWS Primitive Terraform Modules - Development Backlog

This backlog tracks the development of AWS primitive Terraform modules for the SQL Polyglot project migration.

## Overview

All modules must:
- Be created from the generic-skeleton
- Pass all OPA policy tests with `make module-validate` (type: primitive)
- Include comprehensive functional tests using terraform-terratest-framework v1.3.0
- Be 100% reusable, client-agnostic, and application-agnostic
- Support all specifications from terraform_resources_grouped.json

---

## Epic 1: ACM (Certificate Manager) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/acm`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["ACM (Certificate Manager)"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_acm_certificate

**Description:**
Create a reusable ACM certificate primitive module supporting self-signed CA certificates, locally signed client/server certificates, and certificate chains for VPN mutual authentication.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 1.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the ACM module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/acm`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/acm MODULE_TYPE=primitive` passes

#### Story 1.2: Core Resource Implementation
**As a** platform engineer  
**I want** aws_acm_certificate resource implemented  
**So that** I can manage ACM certificates

**Acceptance Criteria:**
- [ ] Implement aws_acm_certificate in main.tf
- [ ] Support required inputs: private_key, certificate_body
- [ ] Support optional inputs: certificate_chain, tags
- [ ] Output: id, arn, domain_name, status
- [ ] Support dependencies on tls_private_key, tls_self_signed_cert, tls_locally_signed_cert

#### Story 1.3: Certificate Type Support
**As a** security engineer  
**I want** support for multiple certificate types  
**So that** I can create CA, client, and server certificates

**Acceptance Criteria:**
- [ ] Support self-signed CA certificates
- [ ] Support locally signed client certificates
- [ ] Support locally signed server certificates
- [ ] Support certificate chains
- [ ] Support custom validity periods (87600 hours)
- [ ] Support custom subject fields (common_name, organization)
- [ ] Support RSA algorithm for private keys

#### Story 1.4: Self-Signed CA Example
**As a** module consumer  
**I want** a self-signed CA example  
**So that** I can test and understand CA certificate creation

**Acceptance Criteria:**
- [ ] Create examples/self-signed-ca/ with self-signed CA certificate configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 1.5: Certificate Chain Example
**As a** module consumer  
**I want** a certificate chain example  
**So that** I can test and understand full certificate chain creation

**Acceptance Criteria:**
- [ ] Create examples/certificate-chain/ with CA + client + server certificates
- [ ] Include certificate chain configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README
- [ ] Note: This example cannot coexist with self-signed-ca due to resource conflicts

#### Story 1.6: Common Tests Implementation
**As a** module maintainer  
**I want** common tests for shared functionality  
**So that** tests aren't duplicated across examples

**Acceptance Criteria:**
- [ ] Create tests/common/module_test.go for tests common to both examples
- [ ] Test module input validation
- [ ] Test required outputs exist (id, arn, domain_name, status)
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make test-common`

#### Story 1.7: Self-Signed CA Tests
**As a** module maintainer  
**I want** self-signed CA specific tests  
**So that** CA certificate functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/self-signed-ca/module_test.go
- [ ] Test uses examples/self-signed-ca/ as fixture
- [ ] Verify CA certificate ARN output
- [ ] Verify certificate status
- [ ] Verify CA-specific attributes
- [ ] Only include tests unique to this example (not in common)
- [ ] All tests pass with `make test`

#### Story 1.8: Certificate Chain Tests
**As a** module maintainer  
**I want** certificate chain specific tests  
**So that** full chain functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/certificate-chain/module_test.go
- [ ] Test uses examples/certificate-chain/ as fixture
- [ ] Verify CA certificate creation
- [ ] Verify client certificate with chain
- [ ] Verify server certificate with chain
- [ ] Verify certificate relationships and chain validity
- [ ] Only include tests unique to this example (not in common)
- [ ] All tests pass with `make test`

#### Story 1.9: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document VPN mutual authentication use case

#### Story 1.10: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/acm MODULE_TYPE=primitive`

---


## Epic 2: Athena Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/athena`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["Athena"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_athena_workgroup

**Description:**
Create a reusable Athena primitive module supporting workgroup configuration, encryption, CloudWatch metrics, and query cost controls.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 2.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the Athena module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/athena`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/athena MODULE_TYPE=primitive` passes

#### Story 2.2: Core Resource Implementation
**As a** platform engineer  
**I want** aws_athena_workgroup resource implemented  
**So that** I can manage Athena workgroups

**Acceptance Criteria:**
- [ ] Implement aws_athena_workgroup in main.tf
- [ ] Support required inputs: name, output_location
- [ ] Support optional inputs: description, force_destroy, enforce_workgroup_configuration, publish_cloudwatch_metrics_enabled, bytes_scanned_cutoff_per_query, encryption_configuration, engine_version, tags
- [ ] Output: id, arn, state

#### Story 2.3: Workgroup Configuration Support
**As a** data engineer  
**I want** comprehensive workgroup configuration support  
**So that** I can configure Athena workgroups for different use cases

**Acceptance Criteria:**
- [ ] Support workgroup naming with validation (1-128 chars, alphanumeric, hyphens, underscores)
- [ ] Support S3 output location configuration
- [ ] Support optional encryption (SSE_S3, SSE_KMS, CSE_KMS)
- [ ] Support CloudWatch metrics enablement
- [ ] Support workgroup configuration enforcement
- [ ] Support query cost controls (bytes_scanned_cutoff_per_query)
- [ ] Support force destroy option
- [ ] Support dynamic encryption configuration
- [ ] Support tags
- [ ] Support use cases: Analytics query execution, Data lake querying, Glue catalog integration

#### Story 2.4: Workgroup Example
**As a** module consumer  
**I want** a workgroup example  
**So that** I can test and understand Athena workgroup configuration

**Acceptance Criteria:**
- [ ] Create examples/workgroup/ with complete workgroup configuration
- [ ] Include S3 output location configuration
- [ ] Include encryption configuration
- [ ] Include CloudWatch metrics enablement
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 2.5: Workgroup Tests
**As a** module maintainer  
**I want** comprehensive workgroup tests  
**So that** workgroup functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/workgroup/module_test.go
- [ ] Test uses examples/workgroup/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (id, arn, state)
- [ ] Verify workgroup ARN output
- [ ] Verify workgroup state
- [ ] Verify S3 output location configuration
- [ ] Verify encryption configuration
- [ ] Verify CloudWatch metrics enablement
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 2.6: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document analytics query execution use case
- [ ] Document data lake querying use case
- [ ] Document Glue catalog integration use case

#### Story 2.7: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/athena MODULE_TYPE=primitive`

---


## Epic 3: CloudWatch Primitive Module (PLACEHOLDER - TO BE UPDATEDt** I can understand simple usage

**Acceptance Criteria:**
- [ ] Create examples/basic
- [ ] Include terraform.tfvars with test values
- [ ] Document example in README

#### Story 2.4: Advanced Example
**As a** module consumer  
**I want** an advanced example  
**So that** I can understand complex usage

**Acceptance Criteria:**
- [ ] Create examples/advanced
- [ ] Include terraform.tfvars with test values
- [ ] Document example in README

#### Story 2.5: Common Tests
**As a** module maintainer  
**I want** common tests implemented  
**So that** basic functionality is verified

**Acceptance Criteria:**
- [ ] Implement tests/common/module_test.go
- [ ] Test idempotency (automatic via framework)
- [ ] Test input validation
- [ ] All tests pass with `make test-common`

#### Story 2.6: Example Tests
**As a** module maintainer  
**I want** example tests implemented  
**So that** usage is verified

**Acceptance Criteria:**
- [ ] Implement tests/basic/module_test.go
- [ ] Implement tests/advanced/module_test.go
- [ ] All tests pass with `make test`

#### Story 2.7: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables
- [ ] Document all outputs
- [ ] Include usage examples in README

#### Story 2.8: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/athena MODULE_TYPE=primitive`

---

## Epic 3: CloudWatch Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/cloudwatch`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["CloudWatch"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_cloudwatch_dashboard
- aws_cloudwatch_query_definition

**Description:**
Create a reusable CloudWatch primitive module supporting dashboards with multiple widget types, custom CloudWatch Insights queries, and comprehensive monitoring capabilities.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 3.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the CloudWatch module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/cloudwatch`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/cloudwatch MODULE_TYPE=primitive` passes

#### Story 3.2: Core Dashboard Resource Implementation
**As a** platform engineer  
**I want** aws_cloudwatch_dashboard resource implemented  
**So that** I can manage CloudWatch dashboards

**Acceptance Criteria:**
- [ ] Implement aws_cloudwatch_dashboard in main.tf
- [ ] Support required inputs: dashboard_name, dashboard_body
- [ ] Support optional inputs: (none specified)
- [ ] Output: dashboard_arn

#### Story 3.3: Dashboard Widget Support
**As a** monitoring engineer  
**I want** comprehensive dashboard widget support  
**So that** I can create rich monitoring dashboards

**Acceptance Criteria:**
- [ ] Support JSON-encoded dashboard body
- [ ] Support multiple widget types (metric, log, text)
- [ ] Support SQS metrics (ApproximateAgeOfOldestMessage, ApproximateNumberOfMessagesVisible, NumberOfMessagesSent)
- [ ] Support Lambda log queries
- [ ] Support custom CloudWatch Insights queries
- [ ] Support widget positioning (x, y, width, height)
- [ ] Support time series and table views
- [ ] Support multiple log sources
- [ ] Support pattern matching in logs

#### Story 3.4: Query Definition Resource Implementation
**As a** platform engineer  
**I want** aws_cloudwatch_query_definition resource implemented  
**So that** I can manage CloudWatch Insights query definitions

**Acceptance Criteria:**
- [ ] Implement aws_cloudwatch_query_definition in main.tf
- [ ] Support required inputs: name, query_string
- [ ] Support optional inputs: log_group_names
- [ ] Output: query_definition_id
- [ ] Support CloudWatch Insights query syntax
- [ ] Support multiple log group sources
- [ ] Support field extraction and filtering
- [ ] Support aggregation (stats, count)
- [ ] Support sorting and limiting results
- [ ] Support custom query naming
- [ ] Support JSON field parsing

#### Story 3.5: Monitoring Dashboard Example
**As a** module consumer  
**I want** a monitoring dashboard example  
**So that** I can test and understand dashboard and query definition creation

**Acceptance Criteria:**
- [ ] Create examples/monitoring-dashboard/ with dashboard and query definitions
- [ ] Include SQS metrics widgets
- [ ] Include Lambda log query widgets
- [ ] Include CloudWatch Insights query definitions
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 3.6: Monitoring Dashboard Tests
**As a** module maintainer  
**I want** comprehensive monitoring dashboard tests  
**So that** dashboard and query functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/monitoring-dashboard/module_test.go
- [ ] Test uses examples/monitoring-dashboard/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (dashboard_arn, query_definition_id)
- [ ] Verify dashboard ARN output
- [ ] Verify query definition ID output
- [ ] Verify dashboard widget configuration
- [ ] Verify query definition configuration
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 3.7: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document monitoring dashboard use case

#### Story 3.8: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/cloudwatch MODULE_TYPE=primitive`

---

## Epic 4: CloudWatch Logs Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/cloudwatch-logs`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["CloudWatch Logs"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_cloudwatch_log_group
- aws_cloudwatch_log_stream

**Description:**
Create a reusable CloudWatch Logs primitive module supporting log groups with custom naming patterns, retention policies, KMS encryption, and log streams for Lambda, VPN, and application logging.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 4.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the CloudWatch Logs module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/cloudwatch-logs`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/cloudwatch-logs MODULE_TYPE=primitive` passes

#### Story 4.2: Core Log Group Resource Implementation
**As a** platform engineer  
**I want** aws_cloudwatch_log_group resource implemented  
**So that** I can manage CloudWatch log groups

**Acceptance Criteria:**
- [ ] Implement aws_cloudwatch_log_group in main.tf
- [ ] Support required inputs: name
- [ ] Support optional inputs: retention_in_days, kms_key_id, tags
- [ ] Output: arn, name

#### Story 4.3: Log Group Configuration Support
**As a** logging engineer  
**I want** comprehensive log group configuration support  
**So that** I can configure log groups for different use cases

**Acceptance Criteria:**
- [ ] Support custom log group naming patterns
- [ ] Support configurable retention periods
- [ ] Support Lambda log group naming (/aws/lambda/{function_name})
- [ ] Support VPN log group naming (/aws/vpn/{project_id}/logs)
- [ ] Support optional KMS encryption
- [ ] Support tags
- [ ] Support use cases: Lambda function logging, VPN connection logging, Application logging

#### Story 4.4: Log Stream Resource Implementation
**As a** platform engineer  
**I want** aws_cloudwatch_log_stream resource implemented  
**So that** I can manage CloudWatch log streams

**Acceptance Criteria:**
- [ ] Implement aws_cloudwatch_log_stream in main.tf
- [ ] Support required inputs: name, log_group_name
- [ ] Support optional inputs: (none specified)
- [ ] Output: arn
- [ ] Support custom stream naming
- [ ] Support association with log groups
- [ ] Support use cases: VPN usage tracking, Application-specific log streams

#### Story 4.5: Log Group and Stream Example
**As a** module consumer  
**I want** a log group and stream example  
**So that** I can test and understand log group and stream creation

**Acceptance Criteria:**
- [ ] Create examples/log-group-stream/ with log group and stream configuration
- [ ] Include retention policy configuration
- [ ] Include KMS encryption configuration
- [ ] Include log stream configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 4.6: Log Group and Stream Tests
**As a** module maintainer  
**I want** comprehensive log group and stream tests  
**So that** logging functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/log-group-stream/module_test.go
- [ ] Test uses examples/log-group-stream/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (log group arn, name, stream arn)
- [ ] Verify log group ARN and name outputs
- [ ] Verify log stream ARN output
- [ ] Verify retention policy configuration
- [ ] Verify KMS encryption configuration
- [ ] Verify log stream association with log group
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 4.7: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document Lambda function logging use case
- [ ] Document VPN connection logging use case
- [ ] Document application logging use case

#### Story 4.8: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/cloudwatch-logs MODULE_TYPE=primitive`

---

## Epic 5: DynamoDB Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/dynamodb`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["DynamoDB"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_dynamodb_table

**Description:**
Create a reusable DynamoDB primitive module supporting multiple billing modes, DynamoDB Streams, Global Secondary Indexes, point-in-time recovery, TTL, encryption, and multi-region replication.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 5.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the DynamoDB module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/dynamodb`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/dynamodb MODULE_TYPE=primitive` passes

#### Story 5.2: Core Table Resource Implementation
**As a** platform engineer  
**I want** aws_dynamodb_table resource implemented  
**So that** I can manage DynamoDB tables

**Acceptance Criteria:**
- [ ] Implement aws_dynamodb_table in main.tf
- [ ] Support required inputs: name, billing_mode, hash_key, attributes
- [ ] Support optional inputs: range_key, stream_enabled, stream_view_type, read_capacity, write_capacity, global_secondary_indexes, point_in_time_recovery, ttl, server_side_encryption, replica, tags
- [ ] Output: id, arn, stream_arn, stream_label

#### Story 5.3: Table Configuration Support
**As a** database engineer  
**I want** comprehensive table configuration support  
**So that** I can configure DynamoDB tables for different use cases

**Acceptance Criteria:**
- [ ] Support PAY_PER_REQUEST and PROVISIONED billing modes
- [ ] Support hash key (partition key) configuration
- [ ] Support optional range key (sort key)
- [ ] Support DynamoDB Streams (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)
- [ ] Support Global Secondary Indexes with projection types (ALL, KEYS_ONLY, INCLUDE)
- [ ] Support point-in-time recovery
- [ ] Support TTL (Time To Live) configuration
- [ ] Support server-side encryption with optional KMS
- [ ] Support multi-region replication
- [ ] Support attribute types (S=String, N=Number, B=Binary)
- [ ] Support dynamic attribute definitions
- [ ] Support dynamic GSI creation
- [ ] Support tags
- [ ] Support use cases: Application data storage, Terraform state locking, Event sourcing with streams, Analytics data collection, Run tracking

#### Story 5.4: DynamoDB Table Example
**As a** module consumer  
**I want** a DynamoDB table example  
**So that** I can test and understand table creation with streams and GSI

**Acceptance Criteria:**
- [ ] Create examples/dynamodb-table/ with complete table configuration
- [ ] Include hash key and range key configuration
- [ ] Include DynamoDB Streams configuration
- [ ] Include Global Secondary Index configuration
- [ ] Include point-in-time recovery configuration
- [ ] Include TTL configuration
- [ ] Include encryption configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 5.5: DynamoDB Table Tests
**As a** module maintainer  
**I want** comprehensive DynamoDB table tests  
**So that** table functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/dynamodb-table/module_test.go
- [ ] Test uses examples/dynamodb-table/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (id, arn, stream_arn, stream_label)
- [ ] Verify table ARN output
- [ ] Verify stream ARN and label outputs
- [ ] Verify hash key and range key configuration
- [ ] Verify DynamoDB Streams configuration
- [ ] Verify GSI configuration
- [ ] Verify point-in-time recovery
- [ ] Verify TTL configuration
- [ ] Verify encryption configuration
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 5.6: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document application data storage use case
- [ ] Document Terraform state locking use case
- [ ] Document event sourcing with streams use case
- [ ] Document analytics data collection use case
- [ ] Document run tracking use case

#### Story 5.7: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/dynamodb MODULE_TYPE=primitive`

---

## Epic 6: EC2 (Elastic Compute Cloud) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/ec2-elastic-compute-cloud`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["EC2 (Elastic Compute Cloud)"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_ec2_client_vpn_endpoint
- aws_ec2_client_vpn_network_association
- aws_ec2_client_vpn_authorization_rule
- aws_ec2_client_vpn_route
- aws_instance
- aws_network_interface

**Description:**
Create a reusable EC2 primitive module supporting Client VPN endpoints with authentication, network associations, authorization rules, routing, EC2 instances with IMDSv2, and network interfaces.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 6.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the EC2 (Elastic Compute Cloud) module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/ec2-elastic-compute-cloud`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/ec2-elastic-compute-cloud MODULE_TYPE=primitive` passes

#### Story 6.2: aws_ec2_client_vpn_endpoint Implementation
**As a** platform engineer  
**I want** aws_ec2_client_vpn_endpoint resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_ec2_client_vpn_endpoint in main.tf
- [ ] Support required inputs: description, server_certificate_arn, client_cidr_block, authentication_options, connection_log_options
- [ ] Support optional inputs: split_tunnel, self_service_portal, security_group_ids, vpc_id, dns_servers, tags
- [ ] Output: id, arn, dns_name
- [ ] Support certificate-based authentication
- [ ] Support federated authentication (SAML)
- [ ] Support split tunnel configuration
- [ ] Support self-service portal
- [ ] Support CloudWatch logging
- [ ] Support custom DNS servers
- [ ] Support security group association
- [ ] Support VPC association
- [ ] Support use cases: Remote VPC access, Secure database connections, Private resource access

#### Story 6.3: aws_ec2_client_vpn_network_association Implementation
**As a** platform engineer  
**I want** aws_ec2_client_vpn_network_association resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_ec2_client_vpn_network_association in main.tf
- [ ] Support required inputs: client_vpn_endpoint_id, subnet_id
- [ ] Support optional inputs: 
- [ ] Output: id, status
- [ ] Support multiple subnet associations
- [ ] Support for_each iteration
- [ ] Support use case: Multi-AZ VPN access

#### Story 6.4: aws_ec2_client_vpn_authorization_rule Implementation
**As a** platform engineer  
**I want** aws_ec2_client_vpn_authorization_rule resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_ec2_client_vpn_authorization_rule in main.tf
- [ ] Support required inputs: client_vpn_endpoint_id, target_network_cidr
- [ ] Support optional inputs: description, authorize_all_groups, access_group_id
- [ ] Output: id
- [ ] Support all groups authorization
- [ ] Support specific group authorization
- [ ] Support CIDR-based access control
- [ ] Support use cases: VPC access, Internet access, Specific network access

#### Story 6.5: aws_ec2_client_vpn_route Implementation
**As a** platform engineer  
**I want** aws_ec2_client_vpn_route resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_ec2_client_vpn_route in main.tf
- [ ] Support required inputs: destination_cidr_block, client_vpn_endpoint_id, target_vpc_subnet_id
- [ ] Support optional inputs: description
- [ ] Output: id
- [ ] Support custom route creation
- [ ] Support timeouts configuration
- [ ] Support dynamic route count
- [ ] Support use cases: Custom network routing, Multi-network access

#### Story 6.6: aws_instance Implementation
**As a** platform engineer  
**I want** aws_instance resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_instance in main.tf
- [ ] Support required inputs: ami, instance_type
- [ ] Support optional inputs: subnet_id, vpc_security_group_ids, iam_instance_profile, user_data, metadata_options, tags
- [ ] Output: id, arn, private_ip, public_ip
- [ ] Support AMI selection
- [ ] Support instance type configuration
- [ ] Support VPC/subnet placement
- [ ] Support security group association
- [ ] Support IAM instance profile
- [ ] Support user data scripts
- [ ] Support IMDSv2 enforcement
- [ ] Support lifecycle ignore_changes
- [ ] Support tags
- [ ] Support use cases: SSM tunnel for database access, Bastion hosts, Application servers

#### Story 6.7: aws_network_interface Implementation
**As a** platform engineer  
**I want** aws_network_interface resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_network_interface in main.tf
- [ ] Support required inputs: subnet_id
- [ ] Support optional inputs: description, security_groups, tags
- [ ] Output: id, private_ip
- [ ] Support multiple security group attachment
- [ ] Support for_each iteration
- [ ] Support zipmap usage
- [ ] Support use cases: Database security group attachment, Multi-SG interfaces

#### Story 6.8: Client VPN Example
**As a** module consumer  
**I want** a Client VPN example  
**So that** I can test and understand VPN endpoint configuration

**Acceptance Criteria:**
- [ ] Create examples/client-vpn/ with VPN endpoint configuration
- [ ] Include network association configuration
- [ ] Include authorization rule configuration
- [ ] Include route configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 6.9: EC2 Instance Example
**As a** module consumer  
**I want** an EC2 instance example  
**So that** I can test and understand instance and network interface configuration

**Acceptance Criteria:**
- [ ] Create examples/ec2-instance/ with instance configuration
- [ ] Include IMDSv2 configuration
- [ ] Include network interface configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README
- [ ] Note: This example cannot coexist with client-vpn due to resource conflicts

#### Story 6.10: Common Tests Implementation
**As a** module maintainer  
**I want** common tests for shared functionality  
**So that** tests aren't duplicated across examples

**Acceptance Criteria:**
- [ ] Create tests/common/module_test.go for tests common to both examples
- [ ] Test module input validation
- [ ] Test required outputs exist based on example
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make test-common`

#### Story 6.11: Client VPN Tests
**As a** module maintainer  
**I want** Client VPN specific tests  
**So that** VPN functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/client-vpn/module_test.go
- [ ] Test uses examples/client-vpn/ as fixture
- [ ] Verify VPN endpoint ARN and DNS name outputs
- [ ] Verify network association status
- [ ] Verify authorization rule configuration
- [ ] Verify route configuration
- [ ] Only include tests unique to this example (not in common)
- [ ] All tests pass with `make tf-test`

#### Story 6.12: EC2 Instance Tests
**As a** module maintainer  
**I want** EC2 instance specific tests  
**So that** instance functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/ec2-instance/module_test.go
- [ ] Test uses examples/ec2-instance/ as fixture
- [ ] Verify instance ARN and IP outputs
- [ ] Verify IMDSv2 configuration
- [ ] Verify network interface configuration
- [ ] Only include tests unique to this example (not in common)
- [ ] All tests pass with `make tf-test`

#### Story 6.13: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document remote VPC access use case
- [ ] Document secure database connections use case
- [ ] Document SSM tunnel for database access use case

#### Story 6.14: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/ec2-elastic-compute-cloud MODULE_TYPE=primitive`

---

## Epic 7: ECR (Elastic Container Registry) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/ecr-elastic-container-registry`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["ECR (Elastic Container Registry)"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_ecr_repository
- aws_ecr_repository_policy
- aws_ecr_lifecycle_policy

**Description:**
Create a reusable ECR primitive module supporting container repositories with encryption, image scanning, repository policies with role-based access control, and lifecycle policies for image retention.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 7.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the ECR (Elastic Container Registry) module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/ecr-elastic-container-registry`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/ecr-elastic-container-registry MODULE_TYPE=primitive` passes

#### Story 7.2: Core Repository Resource Implementation
**As a** platform engineer  
**I want** aws_ecr_repository resource implemented  
**So that** I can manage ECR repositories

**Acceptance Criteria:**
- [ ] Implement aws_ecr_repository in main.tf
- [ ] Support required inputs: name
- [ ] Support optional inputs: image_tag_mutability, encryption_configuration, image_scanning_configuration, tags
- [ ] Output: arn, registry_id, repository_url

#### Story 7.3: Repository Configuration Support
**As a** container engineer  
**I want** comprehensive repository configuration support  
**So that** I can configure ECR repositories for different use cases

**Acceptance Criteria:**
- [ ] Support custom repository naming
- [ ] Support image tag mutability (MUTABLE/IMMUTABLE)
- [ ] Support encryption (AES256 or KMS)
- [ ] Support image scanning on push
- [ ] Support tags
- [ ] Support use cases: Lambda container images, Application container storage

#### Story 7.4: Repository Policy Resource Implementation
**As a** platform engineer  
**I want** aws_ecr_repository_policy resource implemented  
**So that** I can manage ECR repository policies

**Acceptance Criteria:**
- [ ] Implement aws_ecr_repository_policy in main.tf
- [ ] Support required inputs: repository, policy
- [ ] Support optional inputs: (none specified)
- [ ] Output: registry_id
- [ ] Support role-based access control
- [ ] Support HTTPS enforcement
- [ ] Support Lambda service principal access
- [ ] Support conditional access (sourceArn)
- [ ] Support dynamic policy generation
- [ ] Support multiple principal types (AWS, Service)
- [ ] Support use cases: Restrict ECR access to specific roles, Lambda image pull permissions, Security compliance

#### Story 7.5: Lifecycle Policy Resource Implementation
**As a** platform engineer  
**I want** aws_ecr_lifecycle_policy resource implemented  
**So that** I can manage ECR lifecycle policies

**Acceptance Criteria:**
- [ ] Implement aws_ecr_lifecycle_policy in main.tf
- [ ] Support required inputs: repository, policy
- [ ] Support optional inputs: (none specified)
- [ ] Output: registry_id
- [ ] Support conditional creation (count)
- [ ] Support JSON-encoded lifecycle rules
- [ ] Support image expiration rules
- [ ] Support tag-based rules
- [ ] Support use cases: Image cleanup, Cost optimization, Retention policies

#### Story 7.6: ECR Repository Example
**As a** module consumer  
**I want** an ECR repository example  
**So that** I can test and understand repository, policy, and lifecycle configuration

**Acceptance Criteria:**
- [ ] Create examples/ecr-repository/ with complete repository configuration
- [ ] Include encryption configuration
- [ ] Include image scanning configuration
- [ ] Include repository policy configuration
- [ ] Include lifecycle policy configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 7.7: ECR Repository Tests
**As a** module maintainer  
**I want** comprehensive ECR repository tests  
**So that** repository functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/ecr-repository/module_test.go
- [ ] Test uses examples/ecr-repository/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (arn, registry_id, repository_url)
- [ ] Verify repository ARN and URL outputs
- [ ] Verify registry ID output
- [ ] Verify encryption configuration
- [ ] Verify image scanning configuration
- [ ] Verify repository policy configuration
- [ ] Verify lifecycle policy configuration
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 7.8: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document Lambda container images use case
- [ ] Document application container storage use case
- [ ] Document security compliance use case

#### Story 7.9: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/ecr-elastic-container-registry MODULE_TYPE=primitive`

---

## Epic 8: EventBridge Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/eventbridge`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["EventBridge"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_cloudwatch_event_rule
- aws_cloudwatch_event_target

**Description:**
Create a reusable EventBridge primitive module supporting event rules with cron/rate schedules and event patterns, and event targets for Lambda, Step Functions, and SNS with input transformation.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 8.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the EventBridge module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/eventbridge`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/eventbridge MODULE_TYPE=primitive` passes

#### Story 8.2: Core Event Rule Resource Implementation
**As a** platform engineer  
**I want** aws_cloudwatch_event_rule resource implemented  
**So that** I can manage EventBridge rules

**Acceptance Criteria:**
- [ ] Implement aws_cloudwatch_event_rule in main.tf
- [ ] Support required inputs: name
- [ ] Support optional inputs: description, schedule_expression, event_pattern, is_enabled, tags
- [ ] Output: id, arn

#### Story 8.3: Event Rule Configuration Support
**As a** automation engineer  
**I want** comprehensive event rule configuration support  
**So that** I can configure EventBridge rules for different use cases

**Acceptance Criteria:**
- [ ] Support cron schedule expressions
- [ ] Support rate schedule expressions
- [ ] Support event pattern matching
- [ ] Support custom rule naming
- [ ] Support rule descriptions
- [ ] Support enable/disable rules
- [ ] Support use cases: Scheduled Lambda invocations, Database cost management, Automated maintenance tasks

#### Story 8.4: Event Target Resource Implementation
**As a** platform engineer  
**I want** aws_cloudwatch_event_target resource implemented  
**So that** I can manage EventBridge targets

**Acceptance Criteria:**
- [ ] Implement aws_cloudwatch_event_target in main.tf
- [ ] Support required inputs: rule, arn
- [ ] Support optional inputs: target_id, input, input_path, role_arn
- [ ] Output: (none specified)
- [ ] Support Lambda function targets
- [ ] Support JSON input transformation
- [ ] Support custom target IDs
- [ ] Support IAM role for target invocation
- [ ] Support use cases: Lambda invocation, Step Functions execution, SNS notifications

#### Story 8.5: Scheduled Event Example
**As a** module consumer  
**I want** a scheduled event example  
**So that** I can test and understand event rule and target configuration

**Acceptance Criteria:**
- [ ] Create examples/scheduled-event/ with event rule and target configuration
- [ ] Include cron or rate schedule expression
- [ ] Include Lambda target configuration
- [ ] Include input transformation configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 8.6: Scheduled Event Tests
**As a** module maintainer  
**I want** comprehensive scheduled event tests  
**So that** event rule and target functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/scheduled-event/module_test.go
- [ ] Test uses examples/scheduled-event/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (rule id, arn)
- [ ] Verify event rule ARN output
- [ ] Verify schedule expression configuration
- [ ] Verify target configuration
- [ ] Verify input transformation
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 8.7: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document scheduled Lambda invocations use case
- [ ] Document database cost management use case
- [ ] Document automated maintenance tasks use case

#### Story 8.8: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/eventbridge MODULE_TYPE=primitive`

---

## Epic 9: Glue Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/glue`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["Glue"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_glue_catalog_database
- aws_glue_crawler

**Description:**
Create a reusable Glue primitive module supporting catalog databases with custom permissions, and crawlers with S3 targets, schema change policies, and recrawl policies for data catalog discovery.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 9.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the Glue module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/glue`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/glue MODULE_TYPE=primitive` passes

#### Story 9.2: Core Catalog Database Resource Implementation
**As a** platform engineer  
**I want** aws_glue_catalog_database resource implemented  
**So that** I can manage Glue catalog databases

**Acceptance Criteria:**
- [ ] Implement aws_glue_catalog_database in main.tf
- [ ] Support required inputs: name
- [ ] Support optional inputs: description, location_uri, parameters, create_table_default_permission
- [ ] Output: id, arn, catalog_id

#### Story 9.3: Catalog Database Configuration Support
**As a** data engineer  
**I want** comprehensive catalog database configuration support  
**So that** I can configure Glue databases for different use cases

**Acceptance Criteria:**
- [ ] Support custom database naming
- [ ] Support default table permissions
- [ ] Support IAM_ALLOWED_PRINCIPALS configuration
- [ ] Support permission types (ALL, SELECT, ALTER, DROP, DELETE, INSERT)
- [ ] Support use cases: Analytics data catalog, Data lake metadata, Athena query source

#### Story 9.4: Crawler Resource Implementation
**As a** platform engineer  
**I want** aws_glue_crawler resource implemented  
**So that** I can manage Glue crawlers

**Acceptance Criteria:**
- [ ] Implement aws_glue_crawler in main.tf
- [ ] Support required inputs: name, role, database_name
- [ ] Support optional inputs: description, schedule, schema_change_policy, configuration, s3_target, recrawl_policy, tags
- [ ] Output: id, arn, state
- [ ] Support on-demand crawling (no schedule)
- [ ] Support scheduled crawling (cron expressions)
- [ ] Support S3 target configuration
- [ ] Support path exclusions
- [ ] Support schema change policies (LOG, UPDATE_IN_DATABASE, DELETE_FROM_DATABASE)
- [ ] Support recrawl policies (CRAWL_EVERYTHING, CRAWL_NEW_FOLDERS_ONLY)
- [ ] Support custom crawler configuration JSON
- [ ] Support table/partition update behaviors
- [ ] Support IAM role with Glue service principal
- [ ] Support S3, CloudWatch, and KMS permissions
- [ ] Support use cases: Data catalog discovery, Schema evolution tracking, Partition management

#### Story 9.5: Glue Catalog and Crawler Example
**As a** module consumer  
**I want** a Glue catalog and crawler example  
**So that** I can test and understand database and crawler configuration

**Acceptance Criteria:**
- [ ] Create examples/glue-catalog-crawler/ with database and crawler configuration
- [ ] Include catalog database with permissions configuration
- [ ] Include crawler with S3 target configuration
- [ ] Include schema change policy configuration
- [ ] Include recrawl policy configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 9.6: Glue Catalog and Crawler Tests
**As a** module maintainer  
**I want** comprehensive Glue catalog and crawler tests  
**So that** database and crawler functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/glue-catalog-crawler/module_test.go
- [ ] Test uses examples/glue-catalog-crawler/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (database id, arn, catalog_id, crawler id, arn, state)
- [ ] Verify database ARN and catalog ID outputs
- [ ] Verify crawler ARN and state outputs
- [ ] Verify database permissions configuration
- [ ] Verify crawler S3 target configuration
- [ ] Verify schema change policy
- [ ] Verify recrawl policy
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 9.7: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document analytics data catalog use case
- [ ] Document data lake metadata use case
- [ ] Document Athena query source use case
- [ ] Document data catalog discovery use case
- [ ] Document schema evolution tracking use case

#### Story 9.8: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/glue MODULE_TYPE=primitive`

---

## Epic 10: IAM (Identity & Access Management) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/iam-identity-&-access-management`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["IAM (Identity & Access Management)"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_iam_role
- aws_iam_role_policy
- aws_iam_role_policy_attachment
- aws_iam_instance_profile
- aws_iam_openid_connect_provider

**Description:**
Create a reusable IAM primitive module supporting roles with service principals and OIDC, inline and managed policies, instance profiles, and OpenID Connect providers for GitHub Actions authentication.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 10.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the IAM (Identity & Access Management) module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/iam-identity-&-access-management`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/iam-identity-&-access-management MODULE_TYPE=primitive` passes

#### Story 10.2: aws_iam_role Implementation
**As a** platform engineer  
**I want** aws_iam_role resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_iam_role in main.tf
- [ ] Support required inputs: name, assume_role_policy
- [ ] Support optional inputs: description, max_session_duration, permissions_boundary, tags
- [ ] Output: id, arn, unique_id
- [ ] Support service principals (lambda.amazonaws.com, ec2.amazonaws.com, glue.amazonaws.com, etc.)
- [ ] Support AssumeRole trust policies
- [ ] Support AssumeRoleWithWebIdentity for OIDC
- [ ] Support custom role naming
- [ ] Support lifecycle rules (prevent_destroy, ignore_changes)
- [ ] Support conditional assume role policies
- [ ] Support use cases: Lambda execution, EC2 instance profiles, Glue crawlers, GitHub Actions OIDC, Cross-service access

#### Story 10.3: aws_iam_role_policy Implementation
**As a** platform engineer  
**I want** aws_iam_role_policy resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_iam_role_policy in main.tf
- [ ] Support required inputs: name, role, policy
- [ ] Support optional inputs: 
- [ ] Output: id
- [ ] Support inline policy documents
- [ ] Support JSON-encoded policies
- [ ] Support multiple statement blocks
- [ ] Support service-specific permissions (S3, Lambda, DynamoDB, Glue, KMS, EC2, Secrets Manager, RDS, Budgets)
- [ ] Support resource ARN patterns
- [ ] Support conditional policies
- [ ] Support wildcard resources
- [ ] Support use cases: Lambda permissions, Service access control, Cross-service integration

#### Story 10.4: aws_iam_role_policy_attachment Implementation
**As a** platform engineer  
**I want** aws_iam_role_policy_attachment resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_iam_role_policy_attachment in main.tf
- [ ] Support required inputs: role, policy_arn
- [ ] Support optional inputs: 
- [ ] Output: id
- [ ] Support AWS managed policies
- [ ] Support common managed policies (AWSLambdaVPCAccessExecutionRole, AWSLambdaDynamoDBExecutionRole, AmazonSSMManagedInstanceCore, AdministratorAccess, AWSGlueServiceRole)
- [ ] Support multiple attachments per role
- [ ] Support lifecycle rules
- [ ] Support use cases: VPC Lambda access, DynamoDB stream access, SSM instance management, GitHub Actions admin access

#### Story 10.5: aws_iam_instance_profile Implementation
**As a** platform engineer  
**I want** aws_iam_instance_profile resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_iam_instance_profile in main.tf
- [ ] Support required inputs: name, role
- [ ] Support optional inputs: path
- [ ] Output: id, arn, unique_id
- [ ] Support EC2 instance role association
- [ ] Support custom profile naming
- [ ] Support use cases: EC2 SSM access, Instance-based service access

#### Story 10.6: aws_iam_openid_connect_provider Implementation
**As a** platform engineer  
**I want** aws_iam_openid_connect_provider resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_iam_openid_connect_provider in main.tf
- [ ] Support required inputs: url, client_id_list, thumbprint_list
- [ ] Support optional inputs: tags
- [ ] Output: arn
- [ ] Support GitHub Actions OIDC (token.actions.githubusercontent.com)
- [ ] Support thumbprint validation
- [ ] Support lifecycle prevent_destroy
- [ ] Support lifecycle ignore_changes
- [ ] Support use cases: GitHub Actions authentication, CI/CD pipeline access

#### Story 10.7: IAM Role Example
**As a** module consumer  
**I want** an IAM role example  
**So that** I can test and understand role, policy, and instance profile configuration

**Acceptance Criteria:**
- [ ] Create examples/iam-role/ with role, inline policy, and managed policy attachment
- [ ] Include service principal trust policy
- [ ] Include instance profile configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 10.8: OIDC Provider Example
**As a** module consumer  
**I want** an OIDC provider example  
**So that** I can test and understand GitHub Actions OIDC configuration

**Acceptance Criteria:**
- [ ] Create examples/oidc-provider/ with OIDC provider and role configuration
- [ ] Include GitHub Actions OIDC configuration
- [ ] Include AssumeRoleWithWebIdentity trust policy
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README
- [ ] Note: This example cannot coexist with iam-role due to resource conflicts

#### Story 10.9: Common Tests Implementation
**As a** module maintainer  
**I want** common tests for shared functionality  
**So that** tests aren't duplicated across examples

**Acceptance Criteria:**
- [ ] Create tests/common/module_test.go for tests common to both examples
- [ ] Test module input validation
- [ ] Test required outputs exist based on example
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make test-common`

#### Story 10.10: IAM Role Tests
**As a** module maintainer  
**I want** IAM role specific tests  
**So that** role and policy functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/iam-role/module_test.go
- [ ] Test uses examples/iam-role/ as fixture
- [ ] Verify role ARN output
- [ ] Verify inline policy configuration
- [ ] Verify managed policy attachment
- [ ] Verify instance profile ARN output
- [ ] Only include tests unique to this example (not in common)
- [ ] All tests pass with `make tf-test`

#### Story 10.11: OIDC Provider Tests
**As a** module maintainer  
**I want** OIDC provider specific tests  
**So that** OIDC functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/oidc-provider/module_test.go
- [ ] Test uses examples/oidc-provider/ as fixture
- [ ] Verify OIDC provider ARN output
- [ ] Verify role with AssumeRoleWithWebIdentity trust policy
- [ ] Verify GitHub Actions OIDC configuration
- [ ] Only include tests unique to this example (not in common)
- [ ] All tests pass with `make tf-test`

#### Story 10.12: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document Lambda execution use case
- [ ] Document EC2 instance profiles use case
- [ ] Document GitHub Actions OIDC use case
- [ ] Document cross-service access use case

#### Story 10.13: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/iam-identity-&-access-management MODULE_TYPE=primitive`

---

## Epic 11: KMS (Key Management) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/kms-key-management`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["KMS (Key Management)"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_kms_key
- aws_kms_alias

**Description:**
Create a reusable KMS primitive module supporting symmetric and asymmetric keys with rotation, custom deletion windows, key policies, and aliases for S3, Secrets Manager, and DynamoDB encryption.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 11.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the KMS (Key Management) module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/kms-key-management`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/kms-key-management MODULE_TYPE=primitive` passes

#### Story 11.2: Core KMS Key Resource Implementation
**As a** platform engineer  
**I want** aws_kms_key resource implemented  
**So that** I can manage KMS keys

**Acceptance Criteria:**
- [ ] Implement aws_kms_key in main.tf
- [ ] Support required inputs: description
- [ ] Support optional inputs: deletion_window_in_days, enable_key_rotation, policy, customer_master_key_spec, key_usage, multi_region, tags
- [ ] Output: id, arn, key_id

#### Story 11.3: KMS Key Configuration Support
**As a** security engineer  
**I want** comprehensive KMS key configuration support  
**So that** I can configure keys for different use cases

**Acceptance Criteria:**
- [ ] Support symmetric and asymmetric keys
- [ ] Support key rotation enablement
- [ ] Support custom deletion windows (7-30 days)
- [ ] Support key usage types (ENCRYPT_DECRYPT, SIGN_VERIFY)
- [ ] Support key specs (SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, etc.)
- [ ] Support multi-region keys
- [ ] Support custom key policies
- [ ] Support tags
- [ ] Support use cases: S3 encryption, Secrets Manager encryption, DynamoDB encryption, General data encryption

#### Story 11.4: KMS Alias Resource Implementation
**As a** platform engineer  
**I want** aws_kms_alias resource implemented  
**So that** I can manage KMS aliases

**Acceptance Criteria:**
- [ ] Implement aws_kms_alias in main.tf
- [ ] Support required inputs: name, target_key_id
- [ ] Support optional inputs: (none specified)
- [ ] Output: id, arn, target_key_arn
- [ ] Support alias naming with 'alias/' prefix
- [ ] Support key ID association
- [ ] Support human-readable key references
- [ ] Support use cases: Key identification, Application-specific key naming

#### Story 11.5: KMS Key and Alias Example
**As a** module consumer  
**I want** a KMS key and alias example  
**So that** I can test and understand key and alias configuration

**Acceptance Criteria:**
- [ ] Create examples/kms-key-alias/ with key and alias configuration
- [ ] Include key rotation configuration
- [ ] Include deletion window configuration
- [ ] Include alias configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 11.6: KMS Key and Alias Tests
**As a** module maintainer  
**I want** comprehensive KMS key and alias tests  
**So that** key and alias functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/kms-key-alias/module_test.go
- [ ] Test uses examples/kms-key-alias/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (key id, arn, key_id, alias id, arn, target_key_arn)
- [ ] Verify key ARN and key ID outputs
- [ ] Verify alias ARN and target key ARN outputs
- [ ] Verify key rotation configuration
- [ ] Verify deletion window configuration
- [ ] Verify alias association with key
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 11.7: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document S3 encryption use case
- [ ] Document Secrets Manager encryption use case
- [ ] Document DynamoDB encryption use case
- [ ] Document general data encryption use case

#### Story 11.8: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/kms-key-management MODULE_TYPE=primitive`

---

## Epic 12: Lambda Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/lambda`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["Lambda"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_lambda_function
- aws_lambda_event_source_mapping
- aws_lambda_permission

**Description:**
Create a reusable Lambda primitive module supporting Zip and Image package types, event source mappings for SQS and DynamoDB streams, and permissions for service principals with VPC configuration and environment variables.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 12.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the Lambda module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/lambda`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/lambda MODULE_TYPE=primitive` passes

#### Story 12.2: aws_lambda_function Implementation
**As a** platform engineer  
**I want** aws_lambda_function resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_lambda_function in main.tf
- [ ] Support required inputs: function_name, role
- [ ] Support optional inputs: package_type, filename, source_code_hash, handler, runtime, layers, image_uri, image_config, architectures, timeout, memory_size, reserved_concurrent_executions, environment, vpc_config, tags
- [ ] Output: arn, invoke_arn, qualified_arn, version
- [ ] Support Zip package type (with filename, handler, runtime)
- [ ] Support Image package type (with image_uri, image_config)
- [ ] Support architectures (arm64, x86_64)
- [ ] Support timeout configuration (1-900 seconds)
- [ ] Support memory size (128-10240 MB)
- [ ] Support reserved concurrent executions
- [ ] Support Lambda layers
- [ ] Support environment variables
- [ ] Support VPC configuration (subnets, security groups)
- [ ] Support image command override
- [ ] Support dependencies on log groups
- [ ] Support tags
- [ ] Support use cases: Backend processing, Assessment workflows, Analytics pipeline, Cost management, Run tracking

#### Story 12.3: aws_lambda_event_source_mapping Implementation
**As a** platform engineer  
**I want** aws_lambda_event_source_mapping resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_lambda_event_source_mapping in main.tf
- [ ] Support required inputs: event_source_arn, function_name
- [ ] Support optional inputs: batch_size, enabled, starting_position, maximum_batching_window_in_seconds, scaling_config
- [ ] Output: uuid, state
- [ ] Support SQS event sources
- [ ] Support DynamoDB stream event sources
- [ ] Support batch size configuration
- [ ] Support starting position (LATEST, TRIM_HORIZON)
- [ ] Support scaling configuration (maximum_concurrency)
- [ ] Support enable/disable mapping
- [ ] Support multiple event sources per function
- [ ] Support conditional creation (count)
- [ ] Support use cases: SQS queue processing, DynamoDB stream processing, Event-driven architectures

#### Story 12.4: aws_lambda_permission Implementation
**As a** platform engineer  
**I want** aws_lambda_permission resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_lambda_permission in main.tf
- [ ] Support required inputs: statement_id, action, function_name, principal
- [ ] Support optional inputs: source_arn, source_account, event_source_token
- [ ] Output: 
- [ ] Support service principals (sqs.amazonaws.com, dynamodb.amazonaws.com, events.amazonaws.com, sns.amazonaws.com)
- [ ] Support source ARN restrictions
- [ ] Support multiple permissions per function
- [ ] Support conditional creation (count, for_each)
- [ ] Support unique statement IDs
- [ ] Support use cases: SQS invocation, DynamoDB stream invocation, EventBridge invocation, SNS invocation 

#### Story 12.5: Lambda Zip Deployment Example
**As a** module consumer  
**I want** a Lambda Zip deployment example  
**So that** I can test and understand Zip-based Lambda deployment with event sources

**Acceptance Criteria:**
- [ ] Create examples/lambda-zip-deployment/ with complete configuration
- [ ] Include Zip package type configuration (filename, handler, runtime)
- [ ] Include environment variables configuration
- [ ] Include VPC configuration
- [ ] Include event source mapping for SQS or DynamoDB
- [ ] Include Lambda permission configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 12.6: Lambda Docker Image Deployment Example
**As a** module consumer  
**I want** a Lambda Docker image deployment example  
**So that** I can test and understand container-based Lambda deployment

**Acceptance Criteria:**
- [ ] Create examples/lambda-docker-deployment/ with complete configuration
- [ ] Include Image package type configuration (image_uri, image_config)
- [ ] Include image command override configuration
- [ ] Include environment variables configuration
- [ ] Include VPC configuration
- [ ] Include event source mapping for SQS or DynamoDB
- [ ] Include Lambda permission configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 12.7: Common Lambda Tests
**As a** module maintainer  
**I want** common Lambda tests  
**So that** shared functionality across both deployment methods is verified

**Acceptance Criteria:**
- [ ] Create tests/common/module_test.go
- [ ] Test module input validation
- [ ] Test required outputs exist (arn, invoke_arn, qualified_arn, version)
- [ ] Verify function ARN and invoke ARN outputs
- [ ] Verify function version output
- [ ] Verify environment variables configuration
- [ ] Verify VPC configuration
- [ ] Verify event source mapping UUID and state
- [ ] Verify Lambda permission configuration
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 12.8: Lambda Zip Deployment Tests
**As a** module maintainer  
**I want** Zip deployment specific tests  
**So that** Zip package functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/lambda-zip-deployment/module_test.go
- [ ] Test uses examples/lambda-zip-deployment/ as fixture
- [ ] Verify Zip package type configuration
- [ ] Verify handler configuration
- [ ] Verify runtime configuration
- [ ] Verify source code hash handling
- [ ] Verify Lambda layers configuration
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 12.9: Lambda Docker Image Deployment Tests
**As a** module maintainer  
**I want** Docker image deployment specific tests  
**So that** Image package functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/lambda-docker-deployment/module_test.go
- [ ] Test uses examples/lambda-docker-deployment/ as fixture
- [ ] Verify Image package type configuration
- [ ] Verify image URI configuration
- [ ] Verify image command override
- [ ] Verify image config settings
- [ ] Verify architecture configuration (arm64, x86_64)
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 12.10: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README for both Zip and Docker deployments
- [ ] Document backend processing use case
- [ ] Document assessment workflows use case
- [ ] Document analytics pipeline use case
- [ ] Document SQS queue processing use case
- [ ] Document DynamoDB stream processing use case
- [ ] Document Zip vs Image package type selection guidance

#### Story 12.11: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/lambda MODULE_TYPE=primitive`

---

## Epic 13: RDS (Relational Database) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/rds-relational-database`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["RDS (Relational Database)"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_db_instance
- aws_rds_cluster
- aws_rds_cluster_instance
- aws_db_parameter_group
- aws_db_option_group
- aws_db_subnet_group

**Description:**
Create a reusable RDS primitive module supporting standalone DB instances for MySQL/PostgreSQL/Oracle/SQL Server, Aurora clusters with instances, parameter groups, option groups, and subnet groups with encryption and backup configuration.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 13.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the RDS (Relational Database) module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/rds-relational-database`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/rds-relational-database MODULE_TYPE=primitive` passes

#### Story 13.2: aws_db_instance Implementation
**As a** platform engineer  
**I want** aws_db_instance resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_db_instance in main.tf
- [ ] Support required inputs: identifier, engine, instance_class, username, password
- [ ] Support optional inputs: db_name, allocated_storage, engine_version, parameter_group_name, option_group_name, db_subnet_group_name, vpc_security_group_ids, publicly_accessible, backup_retention_period, backup_window, storage_encrypted, skip_final_snapshot, deletion_protection, enabled_cloudwatch_logs_exports, tags
- [ ] Output: id, arn, endpoint, address, port
- [ ] Support multiple engines (mysql, postgres, oracle-ee, oracle-se2, sqlserver-ex, sqlserver-web, sqlserver-se, sqlserver-ee)
- [ ] Support conditional creation (count based on engine type)
- [ ] Support SQL Server specific handling (no db_name)
- [ ] Support storage encryption
- [ ] Support backup configuration
- [ ] Support CloudWatch logs exports
- [ ] Support public/private accessibility
- [ ] Support deletion protection
- [ ] Support license models
- [ ] Support auto minor version upgrades
- [ ] Support apply immediately option
- [ ] Support use cases: Source database, Target database, Non-Aurora RDS instances

#### Story 13.3: aws_rds_cluster Implementation
**As a** platform engineer  
**I want** aws_rds_cluster resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_rds_cluster in main.tf
- [ ] Support required inputs: cluster_identifier, engine, master_username, master_password
- [ ] Support optional inputs: database_name, engine_version, db_subnet_group_name, vpc_security_group_ids, backup_retention_period, preferred_backup_window, storage_encrypted, skip_final_snapshot, apply_immediately, tags
- [ ] Output: id, arn, endpoint, reader_endpoint, cluster_resource_id
- [ ] Support Aurora engines (aurora-mysql, aurora-postgresql)
- [ ] Support conditional creation (count based on engine type)
- [ ] Support cluster-level configuration
- [ ] Support storage encryption
- [ ] Support backup configuration
- [ ] Support apply immediately option
- [ ] Support use cases: Aurora MySQL clusters, Aurora PostgreSQL clusters

#### Story 13.4: aws_rds_cluster_instance Implementation
**As a** platform engineer  
**I want** aws_rds_cluster_instance resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_rds_cluster_instance in main.tf
- [ ] Support required inputs: cluster_identifier, instance_class, engine
- [ ] Support optional inputs: identifier, engine_version, db_subnet_group_name, db_parameter_group_name, publicly_accessible, apply_immediately, tags
- [ ] Output: id, arn, endpoint, port
- [ ] Support Aurora cluster association
- [ ] Support conditional creation (count based on cluster existence)
- [ ] Support instance-level configuration
- [ ] Support public/private accessibility
- [ ] Support apply immediately option
- [ ] Support use case: Aurora cluster instances

#### Story 13.5: aws_db_parameter_group Implementation
**As a** platform engineer  
**I want** aws_db_parameter_group resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_db_parameter_group in main.tf
- [ ] Support required inputs: name, family
- [ ] Support optional inputs: description, parameter, tags
- [ ] Output: id, arn
- [ ] Support conditional creation (count)
- [ ] Support dynamic parameter blocks
- [ ] Support parameter apply methods (immediate, pending-reboot)
- [ ] Support engine family specification
- [ ] Support use cases: Custom database parameters, Performance tuning

#### Story 13.6: aws_db_option_group Implementation
**As a** platform engineer  
**I want** aws_db_option_group resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_db_option_group in main.tf
- [ ] Support required inputs: name, engine_name, major_engine_version
- [ ] Support optional inputs: option_group_description, option, tags
- [ ] Output: id, arn
- [ ] Support conditional creation (count)
- [ ] Support dynamic option blocks
- [ ] Support option settings configuration
- [ ] Support engine-specific options
- [ ] Support use cases: Oracle/SQL Server specific features, Database extensions

#### Story 13.7: aws_db_subnet_group Implementation
**As a** platform engineer  
**I want** aws_db_subnet_group resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_db_subnet_group in main.tf
- [ ] Support required inputs: name, subnet_ids
- [ ] Support optional inputs: description, tags
- [ ] Output: id, arn
- [ ] Support multiple subnet association
- [ ] Support custom naming
- [ ] Support use cases: Multi-AZ database deployment, VPC subnet grouping

#### Story 13.8: RDS Instance Example
**As a** module consumer  
**I want** an RDS instance example  
**So that** I can test and understand standalone DB instance configuration

**Acceptance Criteria:**
- [ ] Create examples/rds-instance/ with DB instance configuration
- [ ] Include parameter group configuration
- [ ] Include option group configuration
- [ ] Include subnet group configuration
- [ ] Include encryption configuration
- [ ] Include backup configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 13.9: Aurora Cluster Example
**As a** module consumer  
**I want** an Aurora cluster example  
**So that** I can test and understand Aurora cluster and instance configuration

**Acceptance Criteria:**
- [ ] Create examples/aurora-cluster/ with cluster and instance configuration
- [ ] Include parameter group configuration
- [ ] Include subnet group configuration
- [ ] Include encryption configuration
- [ ] Include backup configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README
- [ ] Note: This example cannot coexist with rds-instance due to resource conflicts

#### Story 13.10: Common Tests Implementation
**As a** module maintainer  
**I want** common tests for shared functionality  
**So that** tests aren't duplicated across examples

**Acceptance Criteria:**
- [ ] Create tests/common/module_test.go for tests common to both examples
- [ ] Test module input validation
- [ ] Test required outputs exist based on example
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make test-common`

#### Story 13.11: RDS Instance Tests
**As a** module maintainer  
**I want** RDS instance specific tests  
**So that** standalone DB instance functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/rds-instance/module_test.go
- [ ] Test uses examples/rds-instance/ as fixture
- [ ] Verify DB instance ARN and endpoint outputs
- [ ] Verify parameter group configuration
- [ ] Verify option group configuration
- [ ] Verify subnet group configuration
- [ ] Verify encryption configuration
- [ ] Verify backup configuration
- [ ] Only include tests unique to this example (not in common)
- [ ] All tests pass with `make tf-test`

#### Story 13.12: Aurora Cluster Tests
**As a** module maintainer  
**I want** Aurora cluster specific tests  
**So that** Aurora cluster functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/aurora-cluster/module_test.go
- [ ] Test uses examples/aurora-cluster/ as fixture
- [ ] Verify cluster ARN, endpoint, and reader endpoint outputs
- [ ] Verify cluster instance ARN and endpoint outputs
- [ ] Verify parameter group configuration
- [ ] Verify subnet group configuration
- [ ] Verify encryption configuration
- [ ] Verify backup configuration
- [ ] Only include tests unique to this example (not in common)
- [ ] All tests pass with `make tf-test`

#### Story 13.13: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document source database use case
- [ ] Document target database use case
- [ ] Document Aurora MySQL clusters use case
- [ ] Document Aurora PostgreSQL clusters use case

#### Story 13.14: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/rds-relational-database MODULE_TYPE=primitive`

---

## Epic 14: S3 (Simple Storage) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/s3-simple-storage`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["S3 (Simple Storage)"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_s3_bucket
- aws_s3_bucket_versioning
- aws_s3_bucket_ownership_controls
- aws_s3_bucket_acl
- aws_s3_bucket_notification
- aws_s3_bucket_policy
- aws_s3_bucket_public_access_block
- aws_s3_bucket_server_side_encryption_configuration
- aws_s3_object

**Description:**
Create a reusable S3 primitive module supporting buckets with versioning, ownership controls, ACLs, event notifications, policies, public access blocking, encryption, and object management for application storage and analytics.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 14.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the S3 (Simple Storage) module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/s3-simple-storage`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/s3-simple-storage MODULE_TYPE=primitive` passes

#### Story 14.2: aws_s3_bucket Implementation
**As a** platform engineer  
**I want** aws_s3_bucket resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_s3_bucket in main.tf
- [ ] Support required inputs: bucket
- [ ] Support optional inputs: tags, force_destroy
- [ ] Output: id, arn, bucket_domain_name
- [ ] Support custom naming patterns
- [ ] Support lifecycle ignore_changes
- [ ] Support tags
- [ ] Support use cases: Application storage, Analytics data, Terraform state

#### Story 14.3: aws_s3_bucket_versioning Implementation
**As a** platform engineer  
**I want** aws_s3_bucket_versioning resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_s3_bucket_versioning in main.tf
- [ ] Support required inputs: bucket, versioning_configuration
- [ ] Output: id
- [ ] Support Enabled/Suspended status
- [ ] Support use cases: Version control, Data protection

#### Story 14.4: aws_s3_bucket_ownership_controls Implementation
**As a** platform engineer  
**I want** aws_s3_bucket_ownership_controls resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_s3_bucket_ownership_controls in main.tf
- [ ] Support required inputs: bucket, rule
- [ ] Support BucketOwnerPreferred
- [ ] Support ObjectWriter
- [ ] Support BucketOwnerEnforced
- [ ] Support use case: ACL management

#### Story 14.5: aws_s3_bucket_acl Implementation
**As a** platform engineer  
**I want** aws_s3_bucket_acl resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_s3_bucket_acl in main.tf
- [ ] Support required inputs: bucket, acl
- [ ] Support private
- [ ] Support public-read
- [ ] Support public-read-write
- [ ] Support use case: Access control

#### Story 14.6: aws_s3_bucket_notification Implementation
**As a** platform engineer  
**I want** aws_s3_bucket_notification resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_s3_bucket_notification in main.tf
- [ ] Support required inputs: bucket
- [ ] Support optional inputs: queue, topic, lambda_function
- [ ] Support SQS queue notifications
- [ ] Support event types (s3:ObjectCreated:*)
- [ ] Support filter prefix/suffix
- [ ] Support dynamic queue blocks
- [ ] Support conditional creation
- [ ] Support use case: Event-driven processing

#### Story 14.7: aws_s3_bucket_policy Implementation
**As a** platform engineer  
**I want** aws_s3_bucket_policy resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_s3_bucket_policy in main.tf
- [ ] Support required inputs: bucket, policy
- [ ] Support HTTPS enforcement
- [ ] Support role-based access
- [ ] Support QuickSight service roles
- [ ] Support conditional policies
- [ ] Support use cases: Security policies, Access control

#### Story 14.8: aws_s3_bucket_public_access_block Implementation
**As a** platform engineer  
**I want** aws_s3_bucket_public_access_block resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_s3_bucket_public_access_block in main.tf
- [ ] Support required inputs: bucket
- [ ] Support optional inputs: block_public_acls, block_public_policy, ignore_public_acls, restrict_public_buckets
- [ ] Support all block options
- [ ] Support use case: Security hardening

#### Story 14.9: aws_s3_bucket_server_side_encryption_configuration Implementation
**As a** platform engineer  
**I want** aws_s3_bucket_server_side_encryption_configuration resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_s3_bucket_server_side_encryption_configuration in main.tf
- [ ] Support required inputs: bucket, rule
- [ ] Support AES256
- [ ] Support aws:kms
- [ ] Support use case: Data encryption

#### Story 14.10: aws_s3_object Implementation
**As a** platform engineer  
**I want** aws_s3_object resource implemented  
**So that** I can manage this AWS resource

**Acceptance Criteria:**
- [ ] Implement aws_s3_object in main.tf
- [ ] Support required inputs: bucket, key
- [ ] Support optional inputs: source, content, acl
- [ ] Support folder creation
- [ ] Support file upload
- [ ] Support conditional creation
- [ ] Support use cases: Folder structure, VPN certificates

#### Story 14.11: S3 Bucket Example
**As a** module consumer  
**I want** an S3 bucket example  
**So that** I can test and understand bucket configuration with all features

**Acceptance Criteria:**
- [ ] Create examples/s3-bucket/ with complete bucket configuration
- [ ] Include versioning configuration
- [ ] Include ownership controls configuration
- [ ] Include ACL configuration
- [ ] Include notification configuration
- [ ] Include bucket policy configuration
- [ ] Include public access block configuration
- [ ] Include encryption configuration
- [ ] Include S3 object configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 14.12: S3 Bucket Tests
**As a** module maintainer  
**I want** comprehensive S3 bucket tests  
**So that** bucket functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/s3-bucket/module_test.go
- [ ] Test uses examples/s3-bucket/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (id, arn, bucket_domain_name)
- [ ] Verify bucket ARN and domain name outputs
- [ ] Verify versioning configuration
- [ ] Verify ownership controls configuration
- [ ] Verify ACL configuration
- [ ] Verify notification configuration
- [ ] Verify bucket policy configuration
- [ ] Verify public access block configuration
- [ ] Verify encryption configuration
- [ ] Verify S3 object creation
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 14.13: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document application storage use case
- [ ] Document analytics data use case
- [ ] Document Terraform state use case
- [ ] Document event-driven processing use case

#### Story 14.14: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/s3-simple-storage MODULE_TYPE=primitive`

---

## Epic 15: SNS (Simple Notification) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/sns-simple-notification`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["SNS (Simple Notification)"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_sns_topic
- aws_sns_topic_policy
- aws_sns_topic_subscription

**Description:**
Create a reusable SNS primitive module supporting topics with policies for service principals, subscriptions for Lambda invocation, and billing alerts for budget notifications.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 15.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the SNS (Simple Notification) module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/sns-simple-notification`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/sns-simple-notification MODULE_TYPE=primitive` passes

#### Story 15.2: Core Topic Resource Implementation
**As a** platform engineer  
**I want** aws_sns_topic resource implemented  
**So that** I can manage SNS topics

**Acceptance Criteria:**
- [ ] Implement aws_sns_topic in main.tf
- [ ] Support required inputs: name
- [ ] Support optional inputs: display_name, policy, delivery_policy, tags
- [ ] Output: id, arn
- [ ] Support custom naming
- [ ] Support tags
- [ ] Support use cases: Billing alerts, Lambda notifications

#### Story 15.3: Topic Policy Resource Implementation
**As a** platform engineer  
**I want** aws_sns_topic_policy resource implemented  
**So that** I can manage SNS topic policies

**Acceptance Criteria:**
- [ ] Implement aws_sns_topic_policy in main.tf
- [ ] Support required inputs: arn, policy
- [ ] Support account owner permissions
- [ ] Support service principal permissions (budgets.amazonaws.com)
- [ ] Support conditional policies
- [ ] Support use cases: Budget notifications, Cross-service access

#### Story 15.4: Topic Subscription Resource Implementation
**As a** platform engineer  
**I want** aws_sns_topic_subscription resource implemented  
**So that** I can manage SNS topic subscriptions

**Acceptance Criteria:**
- [ ] Implement aws_sns_topic_subscription in main.tf
- [ ] Support required inputs: topic_arn, protocol, endpoint
- [ ] Support Lambda protocol
- [ ] Support multiple subscriptions
- [ ] Support conditional creation
- [ ] Support use case: Lambda invocation from SNS

#### Story 15.5: SNS Topic Example
**As a** module consumer  
**I want** an SNS topic example  
**So that** I can test and understand topic, policy, and subscription configuration

**Acceptance Criteria:**
- [ ] Create examples/sns-topic/ with topic, policy, and subscription configuration
- [ ] Include topic policy with service principal permissions
- [ ] Include Lambda subscription configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 15.6: SNS Topic Tests
**As a** module maintainer  
**I want** comprehensive SNS topic tests  
**So that** topic, policy, and subscription functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/sns-topic/module_test.go
- [ ] Test uses examples/sns-topic/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (id, arn)
- [ ] Verify topic ARN output
- [ ] Verify topic policy configuration
- [ ] Verify subscription configuration
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 15.7: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document billing alerts use case
- [ ] Document Lambda notifications use case
- [ ] Document budget notifications use case

#### Story 15.8: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/sns-simple-notification MODULE_TYPE=primitive`

---

## Epic 16: SQS (Simple Queue) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/sqs-simple-queue`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["SQS (Simple Queue)"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_sqs_queue
- aws_sqs_queue_policy
- aws_sqs_queue_redrive_allow_policy

**Description:**
Create a reusable SQS primitive module supporting queues with dead letter queues, redrive policies, queue policies for S3 event notifications, and redrive allow policies for DLQ configuration.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 16.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the SQS (Simple Queue) module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/sqs-simple-queue`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/sqs-simple-queue MODULE_TYPE=primitive` passes

#### Story 16.2: Core Queue Resource Implementation
**As a** platform engineer  
**I want** aws_sqs_queue resource implemented  
**So that** I can manage SQS queues

**Acceptance Criteria:**
- [ ] Implement aws_sqs_queue in main.tf
- [ ] Support required inputs: name
- [ ] Support optional inputs: visibility_timeout_seconds, receive_wait_time_seconds, delay_seconds, redrive_policy, tags
- [ ] Output: id, arn, url
- [ ] Support main queue and DLQ creation
- [ ] Support redrive policy
- [ ] Support visibility timeout
- [ ] Support delay configuration
- [ ] Support tags
- [ ] Support use cases: Lambda triggers, Dead letter queues

#### Story 16.3: Queue Policy Resource Implementation
**As a** platform engineer  
**I want** aws_sqs_queue_policy resource implemented  
**So that** I can manage SQS queue policies

**Acceptance Criteria:**
- [ ] Implement aws_sqs_queue_policy in main.tf
- [ ] Support required inputs: queue_url, policy
- [ ] Support S3 SendMessage permissions
- [ ] Support source ARN conditions
- [ ] Support conditional creation
- [ ] Support use case: S3 event notifications

#### Story 16.4: Queue Redrive Allow Policy Resource Implementation
**As a** platform engineer  
**I want** aws_sqs_queue_redrive_allow_policy resource implemented  
**So that** I can manage SQS queue redrive allow policies

**Acceptance Criteria:**
- [ ] Implement aws_sqs_queue_redrive_allow_policy in main.tf
- [ ] Support required inputs: queue_url, redrive_allow_policy
- [ ] Support byQueue permission
- [ ] Support source queue ARNs
- [ ] Support use case: DLQ redrive configuration

#### Story 16.5: SQS Queue Example
**As a** module consumer  
**I want** an SQS queue example  
**So that** I can test and understand queue, DLQ, policy, and redrive configuration

**Acceptance Criteria:**
- [ ] Create examples/sqs-queue/ with main queue and DLQ configuration
- [ ] Include redrive policy configuration
- [ ] Include queue policy configuration
- [ ] Include redrive allow policy configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 16.6: SQS Queue Tests
**As a** module maintainer  
**I want** comprehensive SQS queue tests  
**So that** queue, DLQ, policy, and redrive functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/sqs-queue/module_test.go
- [ ] Test uses examples/sqs-queue/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (id, arn, url for main queue and DLQ)
- [ ] Verify main queue ARN and URL outputs
- [ ] Verify DLQ ARN and URL outputs
- [ ] Verify redrive policy configuration
- [ ] Verify queue policy configuration
- [ ] Verify redrive allow policy configuration
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 16.7: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document Lambda triggers use case
- [ ] Document dead letter queues use case
- [ ] Document S3 event notifications use case

#### Story 16.8: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/sqs-simple-queue MODULE_TYPE=primitive`

---

## Epic 17: SSM (Systems Manager) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/ssm-systems-manager`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["SSM (Systems Manager)"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_ssm_parameter

**Description:**
Create a reusable SSM primitive module supporting parameters with String/StringList/SecureString types, Standard/Advanced tiers, KMS encryption, and path-based naming for Lambda configuration and application parameters.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 17.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the SSM (Systems Manager) module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/ssm-systems-manager`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/ssm-systems-manager MODULE_TYPE=primitive` passes

#### Story 17.2: Core Parameter Resource Implementation
**As a** platform engineer  
**I want** aws_ssm_parameter resource implemented  
**So that** I can manage SSM parameters

**Acceptance Criteria:**
- [ ] Implement aws_ssm_parameter in main.tf
- [ ] Support required inputs: name, type, value
- [ ] Support optional inputs: description, tier, key_id
- [ ] Output: arn, version
- [ ] Support for_each iteration
- [ ] Support parameter types (String, StringList, SecureString)
- [ ] Support tiers (Standard, Advanced)
- [ ] Support KMS encryption for SecureString
- [ ] Support path-based naming
- [ ] Support use cases: Lambda configuration, Application parameters

#### Story 17.3: SSM Parameter Example
**As a** module consumer  
**I want** an SSM parameter example  
**So that** I can test and understand parameter configuration

**Acceptance Criteria:**
- [ ] Create examples/ssm-parameter/ with multiple parameter types
- [ ] Include String parameter configuration
- [ ] Include SecureString parameter with KMS encryption
- [ ] Include path-based naming examples
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 17.4: SSM Parameter Tests
**As a** module maintainer  
**I want** comprehensive SSM parameter tests  
**So that** parameter functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/ssm-parameter/module_test.go
- [ ] Test uses examples/ssm-parameter/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (arn, version)
- [ ] Verify parameter ARN outputs
- [ ] Verify parameter version outputs
- [ ] Verify String parameter configuration
- [ ] Verify SecureString parameter with KMS encryption
- [ ] Verify path-based naming
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 17.5: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document Lambda configuration use case
- [ ] Document application parameters use case

#### Story 17.6: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/ssm-systems-manager MODULE_TYPE=primitive`

---

## Epic 18: Secrets Manager Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/secrets-manager`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["Secrets Manager"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_secretsmanager_secret
- aws_secretsmanager_secret_version

**Description:**
Create a reusable Secrets Manager primitive module supporting secrets with KMS encryption, secret versions with lifecycle management, and custom naming patterns for database credentials, API keys, and Slack webhooks.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 18.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the Secrets Manager module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/secrets-manager`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/secrets-manager MODULE_TYPE=primitive` passes

#### Story 18.2: Core Secret Resource Implementation
**As a** platform engineer  
**I want** aws_secretsmanager_secret resource implemented  
**So that** I can manage Secrets Manager secrets

**Acceptance Criteria:**
- [ ] Implement aws_secretsmanager_secret in main.tf
- [ ] Support required inputs: name
- [ ] Support optional inputs: kms_key_id, description, recovery_window_in_days
- [ ] Output: id, arn
- [ ] Support for_each iteration
- [ ] Support KMS encryption
- [ ] Support custom naming patterns
- [ ] Support use cases: Database credentials, API keys, Slack webhooks

#### Story 18.3: Secret Version Resource Implementation
**As a** platform engineer  
**I want** aws_secretsmanager_secret_version resource implemented  
**So that** I can manage Secrets Manager secret versions

**Acceptance Criteria:**
- [ ] Implement aws_secretsmanager_secret_version in main.tf
- [ ] Support required inputs: secret_id, secret_string
- [ ] Support for_each iteration
- [ ] Support lifecycle ignore_changes
- [ ] Support conditional creation based on var.ignore_changes
- [ ] Support use cases: Secret value management, Manual secret updates

#### Story 18.4: Secrets Manager Example
**As a** module consumer  
**I want** a Secrets Manager example  
**So that** I can test and understand secret and version configuration

**Acceptance Criteria:**
- [ ] Create examples/secrets-manager/ with secret and version configuration
- [ ] Include KMS encryption configuration
- [ ] Include multiple secrets with for_each
- [ ] Include secret version configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 18.5: Secrets Manager Tests
**As a** module maintainer  
**I want** comprehensive Secrets Manager tests  
**So that** secret and version functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/secrets-manager/module_test.go
- [ ] Test uses examples/secrets-manager/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (id, arn)
- [ ] Verify secret ARN outputs
- [ ] Verify KMS encryption configuration
- [ ] Verify secret version creation
- [ ] Verify for_each iteration
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 18.6: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document database credentials use case
- [ ] Document API keys use case
- [ ] Document Slack webhooks use case

#### Story 18.7: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/secrets-manager MODULE_TYPE=primitive`

---

## Epic 19: Service Quotas Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/service-quotas`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["Service Quotas"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- aws_servicequotas_service_quota

**Description:**
Create a reusable Service Quotas primitive module supporting quota increase requests for AWS services like Bedrock and Lambda with conditional creation.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 19.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the Service Quotas module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/service-quotas`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/service-quotas MODULE_TYPE=primitive` passes

#### Story 19.2: Core Service Quota Resource Implementation
**As a** platform engineer  
**I want** aws_servicequotas_service_quota resource implemented  
**So that** I can manage service quotas

**Acceptance Criteria:**
- [ ] Implement aws_servicequotas_service_quota in main.tf
- [ ] Support required inputs: quota_code, service_code, value
- [ ] Support optional inputs: (none specified)
- [ ] Output: id, arn

#### Story 19.3: Service Quota Configuration Support
**As a** platform engineer  
**I want** comprehensive service quota configuration support  
**So that** I can request quota increases for different services

**Acceptance Criteria:**
- [ ] Support conditional creation (count)
- [ ] Support multiple service codes (bedrock, lambda, etc.)
- [ ] Support quota code specification
- [ ] Support quota value configuration
- [ ] Support use cases: Bedrock prompt limits, Lambda concurrency limits, Service limit increases

#### Story 19.4: Service Quota Example
**As a** module consumer  
**I want** a service quota example  
**So that** I can test and understand quota increase requests

**Acceptance Criteria:**
- [ ] Create examples/service-quota/ with quota increase configuration
- [ ] Include Bedrock or Lambda quota example
- [ ] Include conditional creation example
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 19.5: Service Quota Tests
**As a** module maintainer  
**I want** comprehensive service quota tests  
**So that** quota functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/service-quota/module_test.go
- [ ] Test uses examples/service-quota/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (id, arn)
- [ ] Verify quota ARN output
- [ ] Verify quota increase request
- [ ] Verify conditional creation
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 19.6: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document Bedrock prompt limits use case
- [ ] Document Lambda concurrency limits use case
- [ ] Document service limit increases use case

#### Story 19.7: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/service-quotas MODULE_TYPE=primitive`

---

## Epic 20: TLS/Crypto Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/tls-crypto`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["TLS/Crypto"]`
**Development Environment:** Caylent devcontainer

**Resources:**
- tls_private_key
- tls_self_signed_cert
- tls_cert_request
- tls_locally_signed_cert
- random_password
- random_string

**Description:**
Create a reusable TLS/Crypto primitive module supporting TLS private keys, self-signed certificates, certificate requests, locally signed certificates, and random password/string generation for VPN certificates and database credentials.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 20.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the TLS/Crypto module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/tls-crypto`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/tls-crypto MODULE_TYPE=primitive` passes

#### Story 20.2: tls_private_key Implementation
**As a** platform engineer  
**I want** tls_private_key resource implemented  
**So that** I can manage TLS private keys

**Acceptance Criteria:**
- [ ] Implement tls_private_key in main.tf
- [ ] Support required inputs: algorithm
- [ ] Support optional inputs: (none specified)
- [ ] Output: private_key_pem, public_key_pem
- [ ] Support RSA algorithm
- [ ] Support key generation
- [ ] Support use case: VPN certificates

#### Story 20.3: tls_self_signed_cert Implementation
**As a** platform engineer  
**I want** tls_self_signed_cert resource implemented  
**So that** I can manage self-signed certificates

**Acceptance Criteria:**
- [ ] Implement tls_self_signed_cert in main.tf
- [ ] Support required inputs: private_key_pem, subject, validity_period_hours, allowed_uses
- [ ] Support optional inputs: (none specified)
- [ ] Output: cert_pem
- [ ] Support CA certificates
- [ ] Support custom validity periods
- [ ] Support subject configuration (common_name, organization)
- [ ] Support allowed uses (cert_signing, crl_signing)
- [ ] Support use case: VPN CA certificates

#### Story 20.4: tls_cert_request Implementation
**As a** platform engineer  
**I want** tls_cert_request resource implemented  
**So that** I can manage certificate requests

**Acceptance Criteria:**
- [ ] Implement tls_cert_request in main.tf
- [ ] Support required inputs: private_key_pem, subject
- [ ] Support optional inputs: (none specified)
- [ ] Output: cert_request_pem
- [ ] Support CSR generation
- [ ] Support subject configuration
- [ ] Support use case: VPN client/server certificates

#### Story 20.5: tls_locally_signed_cert Implementation
**As a** platform engineer  
**I want** tls_locally_signed_cert resource implemented  
**So that** I can manage locally signed certificates

**Acceptance Criteria:**
- [ ] Implement tls_locally_signed_cert in main.tf
- [ ] Support required inputs: cert_request_pem, ca_private_key_pem, ca_cert_pem, validity_period_hours, allowed_uses
- [ ] Support optional inputs: (none specified)
- [ ] Output: cert_pem
- [ ] Support CA signing
- [ ] Support client authentication
- [ ] Support server authentication
- [ ] Support custom validity periods
- [ ] Support use case: VPN client/server certificates

#### Story 20.6: random_password Implementation
**As a** platform engineer  
**I want** random_password resource implemented  
**So that** I can generate random passwords

**Acceptance Criteria:**
- [ ] Implement random_password in main.tf
- [ ] Support required inputs: length
- [ ] Support optional inputs: special, override_special
- [ ] Output: result
- [ ] Support custom length
- [ ] Support special characters
- [ ] Support character overrides
- [ ] Support use case: Database passwords

#### Story 20.7: random_string Implementation
**As a** platform engineer  
**I want** random_string resource implemented  
**So that** I can generate random strings

**Acceptance Criteria:**
- [ ] Implement random_string in main.tf
- [ ] Support required inputs: length
- [ ] Support optional inputs: special, upper, lower, numeric
- [ ] Output: result
- [ ] Support custom length
- [ ] Support character type control (upper, lower, numeric, special)
- [ ] Support use cases: Database usernames, Random identifiers

#### Story 20.8: TLS and Random Generation Example
**As a** module consumer  
**I want** a TLS and random generation example  
**So that** I can test and understand certificate and random value generation

**Acceptance Criteria:**
- [ ] Create examples/tls-random-generation/ with complete configuration
- [ ] Include TLS private key generation
- [ ] Include self-signed certificate generation
- [ ] Include certificate request generation
- [ ] Include locally signed certificate generation
- [ ] Include random password generation
- [ ] Include random string generation
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 20.9: TLS and Random Generation Tests
**As a** module maintainer  
**I want** comprehensive TLS and random generation tests  
**So that** all functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/tls-random-generation/module_test.go
- [ ] Test uses examples/tls-random-generation/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (private_key_pem, public_key_pem, cert_pem, cert_request_pem, random result)
- [ ] Verify TLS private key generation
- [ ] Verify self-signed certificate generation
- [ ] Verify certificate request generation
- [ ] Verify locally signed certificate generation
- [ ] Verify random password generation
- [ ] Verify random string generation
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 20.10: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document VPN certificates use case
- [ ] Document database passwords use case
- [ ] Document database usernames use case
- [ ] Document random identifiers use case

#### Story 20.11: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/tls-crypto MODULE_TYPE=primitive`

---

## Epic 21: VPC (Virtual Private Cloud) Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/vpc-virtual-private-cloud`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["VPC (Virtual Private Cloud)"]`
**Development Environment:** Caylent devcontainer

**IMPORTANT NOTE:** There is already a VPC module in this repository. This epic covers security groups, ingress/egress rules, and VPC endpoints. If the VPC specs from this backlog include resources like subnets or other VPC components aside from security groups and endpoints, those will be extracted into separate primitive modules. It is unlikely that this backlog contains requirements not already met by the current VPC module, but if gaps are identified, the current module will be upgraded rather than duplicating work into a new Terraform module.

**Resources:**
- aws_security_group
- aws_vpc_security_group_ingress_rule
- aws_vpc_security_group_egress_rule
- aws_vpc_endpoint

**Description:**
Create a reusable VPC primitive module supporting security groups with ingress/egress rules for Lambda, database, and VPN security, and VPC endpoints for private AWS service access including S3, DynamoDB, Bedrock, SQS, Secrets Manager, and SSM.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 21.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the VPC (Virtual Private Cloud) module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/vpc-virtual-private-cloud`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/vpc-virtual-private-cloud MODULE_TYPE=primitive` passes

#### Story 21.2: aws_security_group Implementation
**As a** platform engineer  
**I want** aws_security_group resource implemented  
**So that** I can manage security groups

**Acceptance Criteria:**
- [ ] Implement aws_security_group in main.tf
- [ ] Support required inputs: name, vpc_id
- [ ] Support optional inputs: description, ingress, egress, tags
- [ ] Output: id, arn
- [ ] Support custom naming
- [ ] Support VPC association
- [ ] Support ingress/egress rules (inline or separate)
- [ ] Support tags
- [ ] Support use cases: Lambda security, Database security, VPN security

#### Story 21.3: aws_vpc_security_group_ingress_rule Implementation
**As a** platform engineer  
**I want** aws_vpc_security_group_ingress_rule resource implemented  
**So that** I can manage ingress rules

**Acceptance Criteria:**
- [ ] Implement aws_vpc_security_group_ingress_rule in main.tf
- [ ] Support required inputs: security_group_id
- [ ] Support optional inputs: cidr_ipv4, cidr_ipv6, referenced_security_group_id, from_port, to_port, ip_protocol, description
- [ ] Output: id
- [ ] Support CIDR-based rules (IPv4 and IPv6)
- [ ] Support security group references
- [ ] Support port ranges
- [ ] Support IP protocols (tcp, udp, icmp, all)
- [ ] Support conditional creation (count)
- [ ] Support use cases: Database access, VPC access, VPN access

#### Story 21.4: aws_vpc_security_group_egress_rule Implementation
**As a** platform engineer  
**I want** aws_vpc_security_group_egress_rule resource implemented  
**So that** I can manage egress rules

**Acceptance Criteria:**
- [ ] Implement aws_vpc_security_group_egress_rule in main.tf
- [ ] Support required inputs: security_group_id
- [ ] Support optional inputs: cidr_ipv4, referenced_security_group_id, from_port, to_port, ip_protocol, description
- [ ] Output: id
- [ ] Support CIDR-based rules
- [ ] Support security group references
- [ ] Support all traffic rules (0.0.0.0/0)
- [ ] Support port ranges
- [ ] Support IP protocols
- [ ] Support use cases: Outbound access, Database egress

#### Story 21.5: aws_vpc_endpoint Implementation
**As a** platform engineer  
**I want** aws_vpc_endpoint resource implemented  
**So that** I can manage VPC endpoints

**Acceptance Criteria:**
- [ ] Implement aws_vpc_endpoint in main.tf
- [ ] Support required inputs: vpc_id, service_name
- [ ] Support optional inputs: vpc_endpoint_type, subnet_ids, security_group_ids, route_table_ids
- [ ] Output: id, arn
- [ ] Support Gateway endpoints (S3, DynamoDB)
- [ ] Support Interface endpoints (Bedrock, SQS, Secrets Manager, SSM)
- [ ] Support endpoint type specification (Gateway, Interface)
- [ ] Support subnet association for Interface endpoints
- [ ] Support security group association for Interface endpoints
- [ ] Support route table association for Gateway endpoints
- [ ] Support conditional creation (count)
- [ ] Support use case: Private AWS service access

#### Story 21.6: VPC Security and Endpoints Example
**As a** module consumer  
**I want** a VPC security and endpoints example  
**So that** I can test and understand security group and VPC endpoint configuration

**Acceptance Criteria:**
- [ ] Create examples/vpc-security-endpoints/ with complete configuration
- [ ] Include security group configuration
- [ ] Include ingress rule configuration (CIDR and security group reference)
- [ ] Include egress rule configuration
- [ ] Include VPC endpoint configuration (Gateway and Interface)
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 21.7: VPC Security and Endpoints Tests
**As a** module maintainer  
**I want** comprehensive VPC security and endpoints tests  
**So that** all functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/vpc-security-endpoints/module_test.go
- [ ] Test uses examples/vpc-security-endpoints/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (security group id, arn, ingress rule id, egress rule id, endpoint id, arn)
- [ ] Verify security group ARN output
- [ ] Verify ingress rule configuration
- [ ] Verify egress rule configuration
- [ ] Verify VPC endpoint ARN output
- [ ] Verify Gateway endpoint configuration
- [ ] Verify Interface endpoint configuration
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 21.8: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document Lambda security use case
- [ ] Document database security use case
- [ ] Document VPN security use case
- [ ] Document private AWS service access use case

#### Story 21.9: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/vpc-virtual-private-cloud MODULE_TYPE=primitive`

---

## Epic 22: Web Services Budgets Primitive Module

**Module Type:** Primitive
**Module Path:** `providers/aws/primitives/web-services-budgets`
**JSON Specification:** `.amazonq/files/terraform_resources_grouped.json` → `["Web Services Budgets"]`
**Development Environment:** Caylent devcontainer

**IMPORTANT NOTE:** There is already a generic AWS Budgets module in this repository. This epic uses the aws_budgets_budget resource which may overlap with the existing module. Verify whether the existing module meets these requirements before creating a new module. The "Web Services Budgets" name suggests this may be a different AWS resource group than the generic budgets module.

**Resources:**
- aws_budgets_budget

**Description:**
Create a reusable Web Services Budgets primitive module supporting cost budgets with monthly time units, multiple notification thresholds, and SNS topic subscribers for cost monitoring and budget alerts.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and all must_support features.

**Example and Testing Strategy:**
- Examples serve as test fixtures for terraform-terratest-framework
- Only create multiple examples when configurations cannot coexist due to conflicts
- Example folder names should describe the configuration (not "basic"/"advanced")
- Example folder names map directly to test folder names
- When multiple examples exist: tests/common/ contains shared tests, example-specific test folders contain only unique tests
- When single example exists: no tests/common/ folder needed, all tests in the example's test folder
- Pipeline handles lint, format, and plan validation - do not duplicate in tests
- Tests focus on functional validation: resource creation, outputs, and module-specific behavior

### Stories

#### Story 22.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the Web Services Budgets module scaffolded from generic-skeleton  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/primitives/web-services-budgets`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata (README, VERSION, etc.)
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/primitives/web-services-budgets MODULE_TYPE=primitive` passes

#### Story 22.2: Core Budget Resource Implementation
**As a** platform engineer  
**I want** aws_budgets_budget resource implemented  
**So that** I can manage AWS budgets

**Acceptance Criteria:**
- [ ] Implement aws_budgets_budget in main.tf
- [ ] Support required inputs: name, budget_type, limit_amount, limit_unit, time_unit
- [ ] Support optional inputs: time_period_start, notification
- [ ] Output: id, arn

#### Story 22.3: Budget Configuration Support
**As a** cost management engineer  
**I want** comprehensive budget configuration support  
**So that** I can configure budgets for different monitoring needs

**Acceptance Criteria:**
- [ ] Support COST budget type
- [ ] Support MONTHLY time unit
- [ ] Support custom budget naming
- [ ] Support limit amount configuration
- [ ] Support limit unit (USD)
- [ ] Support time period start configuration
- [ ] Support multiple notifications
- [ ] Support percentage thresholds (e.g., 80%, 100%)
- [ ] Support comparison operators (GREATER_THAN)
- [ ] Support notification types (ACTUAL, FORECASTED)
- [ ] Support SNS topic subscribers
- [ ] Support subscriber email addresses
- [ ] Support use cases: Cost monitoring, Budget alerts

#### Story 22.4: Budget Example
**As a** module consumer  
**I want** a budget example  
**So that** I can test and understand budget configuration

**Acceptance Criteria:**
- [ ] Create examples/budget/ with complete budget configuration
- [ ] Include COST budget type
- [ ] Include MONTHLY time unit
- [ ] Include multiple notification thresholds
- [ ] Include SNS topic subscriber configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 22.5: Budget Tests
**As a** module maintainer  
**I want** comprehensive budget tests  
**So that** budget functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/budget/module_test.go
- [ ] Test uses examples/budget/ as fixture
- [ ] Test module input validation
- [ ] Test required outputs exist (id, arn)
- [ ] Verify budget ARN output
- [ ] Verify budget type configuration
- [ ] Verify time unit configuration
- [ ] Verify limit amount and unit
- [ ] Verify notification configuration
- [ ] Verify SNS topic subscriber configuration
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 22.6: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can use the module effectively

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document all variables with descriptions and defaults
- [ ] Document all outputs
- [ ] Include usage examples in README
- [ ] Document cost monitoring use case
- [ ] Document budget alerts use case

#### Story 22.7: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/primitives/web-services-budgets MODULE_TYPE=primitive`

---

## Summary

**Total Epics:** 22
- **Primitive Modules:** 22 epics (ACM through Web Services Budgets)

**Reference Modules:**
- Reference modules have been moved to aws-reference-modules-backlog.md
- See aws-reference-modules-backlog.md for Backend, Assessment, and Supporting Services reference modules

**Next Steps:**
1. Develop primitive modules (Epics 1-22)
2. Develop reference modules using primitives (see aws-reference-modules-backlog.md)
3. Create Terragrunt deployment in separate repository
4. Migrate from existing `/tmp/sql-polyglot/terraform` to new modules

**Module Hierarchy:**
```
Primitives (22 modules) → this backlog
    ↓
References (3 modules) → see aws-reference-modules-backlog.md
    ↓
Terragrunt Deployment (separate repo)
```
