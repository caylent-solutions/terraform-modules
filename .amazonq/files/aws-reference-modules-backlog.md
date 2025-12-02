# AWS Reference Terraform Modules - Development Backlog

This backlog tracks the development of AWS reference Terraform modules for the SQL Polyglot project migration.

## Overview

All modules must:
- Be created from the generic-skeleton
- Pass all OPA policy tests with `make module-validate` (type: reference)
- Include comprehensive functional tests using terraform-terratest-framework v1.3.0
- Compose primitive modules into production-ready architectures
- Follow best practices for security, observability, and scalability

Reference modules are production-ready compositions of primitive modules that provide complete, secure, observable architectures following AWS best practices.

---

## Epic 1: SQL Polyglot Backend Reference Module

**Module Type:** Reference
**Module Path:** `providers/aws/references/sql-polyglot-backend`
**Development Environment:** Caylent devcontainer

**Description:**
Create a production-ready reference module for the SQL Polyglot Backend that composes primitive modules into a complete, secure, observable architecture following best practices. This module orchestrates 6 Lambda functions, storage (S3, DynamoDB, RDS), messaging (SQS), networking (VPC), monitoring (CloudWatch), and security (IAM, KMS, Secrets Manager) to provide a fully integrated SQL translation and analysis platform.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and integration between composed primitives.

**Example and Testing Strategy:**
- Reference modules compose multiple primitive modules into production-ready architectures
- Examples demonstrate complete deployment scenarios (basic and production configurations)
- Tests validate integration between primitives and end-to-end functionality
- Pipeline handles lint, format, and plan validation - tests focus on deployment success and integration
- Use descriptive example names that reflect deployment scenarios

**Consumes Primitives:**
- Lambda, S3, DynamoDB, SQS, RDS, VPC, IAM, CloudWatch, Secrets Manager, SSM, ECR, Service Quotas

### Stories

#### Story 1.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the SQL Polyglot Backend reference module scaffolded  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/references/sql-polyglot-backend`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata for reference type
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/references/sql-polyglot-backend MODULE_TYPE=reference` passes

#### Story 1.2: Compute Layer Implementation
**As a** platform engineer  
**I want** 6 Lambda functions implemented using primitive modules  
**So that** backend processing is available

**Acceptance Criteria:**
- [ ] Implement translator Lambda using lambda primitive
- [ ] Implement compiler Lambda using lambda primitive
- [ ] Implement validator Lambda using lambda primitive
- [ ] Implement validation_case_generator Lambda using lambda primitive
- [ ] Implement sql_analyzer Lambda using lambda primitive
- [ ] Implement optimization Lambda using lambda primitive
- [ ] Configure Docker image support via ECR primitive
- [ ] Configure VPC integration for all Lambdas
- [ ] Configure environment variables and timeout settings
- [ ] Configure Lambda layers and architectures

#### Story 1.3: Storage Layer Implementation
**As a** platform engineer  
**I want** storage resources implemented  
**So that** data persistence is available

**Acceptance Criteria:**
- [ ] Implement 6 S3 buckets using s3 primitive (one per Lambda)
- [ ] Implement 4 DynamoDB tables using dynamodb primitive
- [ ] Configure S3 notifications to SQS
- [ ] Configure DynamoDB streams
- [ ] Implement source and target RDS databases using rds primitive
- [ ] Configure encryption for all storage resources
- [ ] Configure versioning and lifecycle policies

#### Story 1.4: Messaging Layer Implementation
**As a** platform engineer  
**I want** messaging infrastructure implemented  
**So that** event-driven processing is available

**Acceptance Criteria:**
- [ ] Implement 6 SQS queues using sqs primitive (one per Lambda)
- [ ] Implement 6 DLQs using sqs primitive
- [ ] Configure queue policies for S3 events
- [ ] Configure Lambda event source mappings
- [ ] Configure visibility timeouts and redrive policies

#### Story 1.5: Networking Layer Implementation
**As a** platform engineer  
**I want** networking infrastructure implemented  
**So that** secure connectivity is available

**Acceptance Criteria:**
- [ ] Implement VPC using vpc primitive
- [ ] Implement security groups using vpc primitive
- [ ] Implement VPC endpoints using vpc primitive
- [ ] Configure private/public/database subnets
- [ ] Configure NAT gateway
- [ ] Configure security group rules for Lambda, RDS, and VPC endpoints

#### Story 1.6: Monitoring & Observability
**As a** platform engineer  
**I want** monitoring infrastructure implemented  
**So that** observability is available

**Acceptance Criteria:**
- [ ] Implement CloudWatch dashboard using cloudwatch primitive
- [ ] Implement CloudWatch query definitions using cloudwatch primitive
- [ ] Configure log groups for all Lambdas using cloudwatch-logs primitive
- [ ] Configure metrics and alarms
- [ ] Configure log retention policies

#### Story 1.7: Security & Configuration
**As a** security engineer  
**I want** security and configuration management  
**So that** the system is secure

**Acceptance Criteria:**
- [ ] Implement IAM roles using iam primitive (one per Lambda)
- [ ] Implement Secrets Manager secrets using secrets-manager primitive
- [ ] Implement SSM parameters using ssm primitive
- [ ] Implement KMS keys using kms primitive
- [ ] Configure service quotas using service-quotas primitive
- [ ] Configure least-privilege IAM policies
- [ ] Configure encryption keys for all encrypted resources

#### Story 1.8: Backend Deployment Example
**As a** module consumer  
**I want** a backend deployment example  
**So that** I can deploy the complete SQL Polyglot Backend

**Acceptance Criteria:**
- [ ] Create examples/backend-deployment/ with complete backend configuration
- [ ] Include all 6 Lambda functions
- [ ] Include all storage, messaging, networking, and security resources
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 1.9: Backend Deployment Tests
**As a** module maintainer  
**I want** comprehensive backend deployment tests  
**So that** integration and deployment functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/backend-deployment/module_test.go
- [ ] Test uses examples/backend-deployment/ as fixture
- [ ] Verify all Lambda functions are deployed
- [ ] Verify S3 buckets, DynamoDB tables, and RDS databases are created
- [ ] Verify SQS queues and event source mappings are configured
- [ ] Verify VPC, security groups, and endpoints are created
- [ ] Verify CloudWatch dashboards and log groups are created
- [ ] Verify IAM roles and policies are configured
- [ ] Test integration between primitives (e.g., S3 → SQS → Lambda)
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 1.10: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can deploy the backend

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document architecture diagram
- [ ] Document deployment process
- [ ] Document all variables and outputs
- [ ] Document primitive module dependencies
- [ ] Document integration points between components
- [ ] Include troubleshooting guide

#### Story 1.11: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the reference module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/references/sql-polyglot-backend MODULE_TYPE=reference`

---

## Epic 2: SQL Polyglot Assessment Frontend Reference Module

**Module Type:** Reference
**Module Path:** `providers/aws/references/sql-polyglot-assessment`
**Development Environment:** Caylent devcontainer

**Description:**
Create a production-ready reference module for the SQL Polyglot Assessment Frontend that composes primitive modules into a complete assessment workflow architecture. This module orchestrates 4 Lambda functions, storage (S3, DynamoDB), messaging (SQS), networking (VPC), monitoring (CloudWatch), and security (IAM, Secrets Manager) to provide a fully integrated SQL assessment and validation platform with backend integration for analytics.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and integration between composed primitives.

**Example and Testing Strategy:**
- Reference modules compose multiple primitive modules into production-ready architectures
- Examples demonstrate complete deployment scenarios (assessment deployment)
- Tests validate integration between primitives and end-to-end functionality
- Pipeline handles lint, format, and plan validation - tests focus on deployment success and integration
- Use descriptive example names that reflect deployment scenarios

**Consumes Primitives:**
- Lambda, S3, DynamoDB, SQS, VPC, IAM, CloudWatch, Secrets Manager, ECR

### Stories

#### Story 2.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the Assessment Frontend reference module scaffolded  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/references/sql-polyglot-assessment`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata for reference type
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/references/sql-polyglot-assessment MODULE_TYPE=reference` passes

#### Story 2.2: Compute Layer Implementation
**As a** platform engineer  
**I want** 4 Lambda functions implemented using primitive modules  
**So that** assessment processing is available

**Acceptance Criteria:**
- [ ] Implement assessment Lambda using lambda primitive
- [ ] Implement assessment_workflow Lambda using lambda primitive
- [ ] Implement assessment_queue_dispatcher Lambda using lambda primitive
- [ ] Implement basic_workflow Lambda using lambda primitive
- [ ] Configure Docker image support via ECR primitive
- [ ] Configure VPC integration for all Lambdas
- [ ] Configure environment variables and timeout settings
- [ ] Configure Lambda layers and architectures

#### Story 2.3: Storage Layer Implementation
**As a** platform engineer  
**I want** storage resources implemented  
**So that** assessment data persistence is available

**Acceptance Criteria:**
- [ ] Implement assessment S3 bucket using s3 primitive
- [ ] Implement 2 DynamoDB tables using dynamodb primitive (assessment data, workflow state)
- [ ] Configure S3 notifications to SQS
- [ ] Configure DynamoDB streams for analytics integration
- [ ] Configure encryption for all storage resources
- [ ] Configure versioning and lifecycle policies

#### Story 2.4: Messaging Layer Implementation
**As a** platform engineer  
**I want** messaging infrastructure implemented  
**So that** event-driven assessment processing is available

**Acceptance Criteria:**
- [ ] Implement 3 SQS queues using sqs primitive (assessment, workflow, dispatcher)
- [ ] Implement DLQs using sqs primitive
- [ ] Configure queue policies for S3 events
- [ ] Configure Lambda event source mappings
- [ ] Configure visibility timeouts and redrive policies

#### Story 2.5: Networking Layer Implementation
**As a** platform engineer  
**I want** networking infrastructure implemented  
**So that** secure connectivity is available

**Acceptance Criteria:**
- [ ] Share VPC with backend using vpc primitive outputs
- [ ] Implement security groups using vpc primitive
- [ ] Configure security group rules for Lambda and DynamoDB
- [ ] Configure VPC endpoints for AWS services

#### Story 2.6: Monitoring & Observability
**As a** platform engineer  
**I want** monitoring infrastructure implemented  
**So that** observability is available

**Acceptance Criteria:**
- [ ] Implement CloudWatch dashboard using cloudwatch primitive
- [ ] Configure log groups for all Lambdas using cloudwatch-logs primitive
- [ ] Configure metrics and alarms
- [ ] Configure log retention policies

#### Story 2.7: Security & Configuration
**As a** security engineer  
**I want** security and configuration management  
**So that** the system is secure

**Acceptance Criteria:**
- [ ] Implement IAM roles using iam primitive (one per Lambda)
- [ ] Implement Secrets Manager secrets using secrets-manager primitive
- [ ] Configure least-privilege IAM policies
- [ ] Configure cross-service permissions for backend integration

#### Story 2.8: Backend Integration
**As a** platform engineer  
**I want** integration with backend services  
**So that** assessment results flow to analytics

**Acceptance Criteria:**
- [ ] Configure DynamoDB stream to analytics Lambda (from backend module)
- [ ] Configure run tracking integration
- [ ] Configure IAM cross-service permissions
- [ ] Configure shared VPC networking

#### Story 2.9: Assessment Deployment Example
**As a** module consumer  
**I want** an assessment deployment example  
**So that** I can deploy the complete SQL Polyglot Assessment Frontend

**Acceptance Criteria:**
- [ ] Create examples/assessment-deployment/ with complete assessment configuration
- [ ] Include all 4 Lambda functions
- [ ] Include all storage, messaging, networking, and security resources
- [ ] Include backend integration configuration
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 2.10: Assessment Deployment Tests
**As a** module maintainer  
**I want** comprehensive assessment deployment tests  
**So that** integration and deployment functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/assessment-deployment/module_test.go
- [ ] Test uses examples/assessment-deployment/ as fixture
- [ ] Verify all Lambda functions are deployed
- [ ] Verify S3 bucket and DynamoDB tables are created
- [ ] Verify SQS queues and event source mappings are configured
- [ ] Verify VPC and security groups are configured
- [ ] Verify CloudWatch dashboards and log groups are created
- [ ] Verify IAM roles and policies are configured
- [ ] Test integration between primitives (e.g., S3 → SQS → Lambda)
- [ ] Test backend integration (DynamoDB streams to analytics)
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 2.11: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can deploy the assessment frontend

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document architecture diagram
- [ ] Document deployment process
- [ ] Document all variables and outputs
- [ ] Document primitive module dependencies
- [ ] Document integration points with backend
- [ ] Include troubleshooting guide

#### Story 2.12: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the reference module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/references/sql-polyglot-assessment MODULE_TYPE=reference`

---

## Epic 3: SQL Polyglot Supporting Services Reference Module

**Module Type:** Reference
**Module Path:** `providers/aws/references/sql-polyglot-supporting-services`
**Development Environment:** Caylent devcontainer

**Description:**
Create a production-ready reference module for SQL Polyglot Supporting Services that composes primitive modules into a complete operational support architecture. This module orchestrates 4 Lambda functions (analytics, run tracking, alerting, DB cost manager), analytics infrastructure (S3, Glue, Athena), monitoring (CloudWatch), messaging (SNS), scheduling (EventBridge), and budgeting (AWS Budgets) to provide comprehensive analytics, tracking, alerting, and cost optimization capabilities.

**Testing Requirements:**
All modules must include comprehensive functional tests using terraform-terratest-framework v1.3.0 that validate the module's functionality, including idempotency, input validation, and integration between composed primitives.

**Example and Testing Strategy:**
- Reference modules compose multiple primitive modules into production-ready architectures
- Examples demonstrate complete deployment scenarios (supporting services deployment)
- Tests validate integration between primitives and end-to-end functionality
- Pipeline handles lint, format, and plan validation - tests focus on deployment success and integration
- Use descriptive example names that reflect deployment scenarios

**Consumes Primitives:**
- Lambda, S3, DynamoDB, SNS, Glue, Athena, CloudWatch, IAM, Secrets Manager, EventBridge, Web Services Budgets

### Stories

#### Story 3.1: Module Scaffolding
**As a** DevOps engineer  
**I want** the Supporting Services reference module scaffolded  
**So that** it follows monorepo standards

**Acceptance Criteria:**
- [ ] Copy generic-skeleton to `providers/aws/references/sql-polyglot-supporting-services`
- [ ] Run `make cpm-configure` and `make install`
- [ ] Update module metadata for reference type
- [ ] Verify `make module-validate MODULE_PATH=providers/aws/references/sql-polyglot-supporting-services MODULE_TYPE=reference` passes

#### Story 3.2: Analytics Pipeline Implementation
**As a** platform engineer  
**I want** analytics pipeline implemented using primitive modules  
**So that** data analytics is available

**Acceptance Criteria:**
- [ ] Implement analytics Lambda using lambda primitive
- [ ] Implement analytics S3 bucket using s3 primitive
- [ ] Implement Glue database using glue primitive
- [ ] Implement Glue crawler using glue primitive
- [ ] Implement Athena workgroup using athena primitive
- [ ] Configure DynamoDB stream event sources from backend/assessment modules
- [ ] Configure Lambda VPC integration
- [ ] Configure S3 bucket policies and encryption
- [ ] Configure Glue crawler schedules and targets

#### Story 3.3: Run Tracking Implementation
**As a** platform engineer  
**I want** run tracking implemented using primitive modules  
**So that** execution tracking is available

**Acceptance Criteria:**
- [ ] Implement run tracking Lambda using lambda primitive
- [ ] Implement run tracking DynamoDB table using dynamodb primitive
- [ ] Configure DynamoDB stream processing
- [ ] Configure SQS integration for external workflow
- [ ] Configure Lambda event source mappings
- [ ] Configure DynamoDB table with streams enabled

#### Story 3.4: Alerting System Implementation
**As a** platform engineer  
**I want** alerting system implemented using primitive modules  
**So that** budget alerts are available

**Acceptance Criteria:**
- [ ] Implement alerting Lambda using lambda primitive
- [ ] Implement SNS topic using sns primitive
- [ ] Implement AWS Budget using web-services-budgets primitive
- [ ] Implement Secrets Manager for Slack webhook using secrets-manager primitive
- [ ] Configure budget notifications to SNS
- [ ] Configure SNS subscription to Lambda
- [ ] Configure Lambda to send Slack notifications

#### Story 3.5: DB Cost Manager Implementation
**As a** platform engineer  
**I want** DB cost manager implemented using primitive modules  
**So that** database cost optimization is available

**Acceptance Criteria:**
- [ ] Implement DB cost manager Lambda using lambda primitive
- [ ] Implement EventBridge rule using eventbridge primitive
- [ ] Configure scheduled database stop/start (cron expressions)
- [ ] Configure IAM permissions for RDS operations
- [ ] Configure EventBridge target to Lambda
- [ ] Configure Lambda environment variables for RDS instance IDs

#### Story 3.6: Monitoring & Security
**As a** platform engineer  
**I want** monitoring and security infrastructure implemented  
**So that** observability and security are available

**Acceptance Criteria:**
- [ ] Implement CloudWatch log groups using cloudwatch-logs primitive
- [ ] Implement IAM roles using iam primitive (one per Lambda)
- [ ] Configure least-privilege IAM policies
- [ ] Configure log retention policies
- [ ] Configure cross-service permissions

#### Story 3.7: Supporting Services Deployment Example
**As a** module consumer  
**I want** a supporting services deployment example  
**So that** I can deploy the complete SQL Polyglot Supporting Services

**Acceptance Criteria:**
- [ ] Create examples/supporting-services-deployment/ with complete configuration
- [ ] Include all 4 Lambda functions
- [ ] Include analytics pipeline (S3, Glue, Athena)
- [ ] Include run tracking (Lambda, DynamoDB)
- [ ] Include alerting system (Lambda, SNS, Budget, Secrets Manager)
- [ ] Include DB cost manager (Lambda, EventBridge)
- [ ] Include terraform.tfvars with test values
- [ ] Example serves as test fixture for terratest
- [ ] Document example in README

#### Story 3.8: Supporting Services Deployment Tests
**As a** module maintainer  
**I want** comprehensive supporting services deployment tests  
**So that** integration and deployment functionality is verified

**Acceptance Criteria:**
- [ ] Create tests/supporting-services-deployment/module_test.go
- [ ] Test uses examples/supporting-services-deployment/ as fixture
- [ ] Verify all Lambda functions are deployed
- [ ] Verify analytics infrastructure (S3, Glue, Athena) is created
- [ ] Verify run tracking DynamoDB table is created
- [ ] Verify alerting system (SNS, Budget, Secrets Manager) is configured
- [ ] Verify DB cost manager EventBridge rule is configured
- [ ] Verify CloudWatch log groups are created
- [ ] Verify IAM roles and policies are configured
- [ ] Test integration between primitives (e.g., Budget → SNS → Lambda)
- [ ] Idempotency testing handled automatically by terraform-terratest-framework
- [ ] Do NOT test lint, format, or plan (handled by pipeline)
- [ ] All tests pass with `make tf-test`

#### Story 3.9: Documentation
**As a** module consumer  
**I want** complete documentation  
**So that** I can deploy supporting services

**Acceptance Criteria:**
- [ ] Generate terraform-docs with `make tf-docs`
- [ ] Document architecture diagram
- [ ] Document deployment process
- [ ] Document all variables and outputs
- [ ] Document primitive module dependencies
- [ ] Document integration points with backend and assessment modules
- [ ] Include troubleshooting guide

#### Story 3.10: Security & Validation
**As a** security engineer  
**I want** security scanning and validation  
**So that** the reference module is secure

**Acceptance Criteria:**
- [ ] Pass `make tf-security` (tfsec)
- [ ] Pass `make tf-lint`
- [ ] Pass `make tf-format`
- [ ] Pass `make tf-test`
- [ ] Pass `make module-validate MODULE_PATH=providers/aws/references/sql-polyglot-supporting-services MODULE_TYPE=reference`

---

## Summary

**Total Epics:** 3
- **Reference Modules:** 3 epics (Backend, Assessment, Supporting Services)

**Dependencies:**
- All reference modules depend on primitive modules being developed first
- Reference modules compose primitives into production-ready architectures

**Next Steps:**
1. Ensure all required primitive modules are completed (see aws-primitive-modules-backlog.md)
2. Develop reference modules using completed primitives (Epics 1-3)
3. Create Terragrunt deployment in separate repository
4. Migrate from existing `/tmp/sql-polyglot/terraform` to new modules

**Module Hierarchy:**
```
Primitives (22 modules) → see aws-primitive-modules-backlog.md
    ↓
References (3 modules) → this backlog
    ↓
Terragrunt Deployment (separate repo)
```
