# Basic Example Tests

## Overview

Tests for the `basic` example of the `managed-grafana-workspace` module.
Provisions a Grafana workspace using AWS SSO authentication and validates the
workspace ID, ARN, and endpoint URL.

## Test Strategy

All assertions run in a single provision cycle for efficiency.

### Process Flow

1. **Provision Once**: Deploy the `basic` example (Grafana workspace with AWS SSO)
2. **Run All Subtests**: Execute all assertions as Go subtests
3. **Idempotency Test**: Framework automatically validates `terraform plan` shows no changes
4. **Destroy Once**: Tear down all infrastructure

## Test Suite: TestManagedGrafanaWorkspaceBasic

### Subtests

#### 1. WorkspaceID

Validates that the workspace ID is non-empty and matches the Grafana workspace ID pattern (`g-` prefix).

#### 2. WorkspaceARN

Validates that the workspace ARN is non-empty and matches the expected format for
Amazon Managed Grafana (`arn:aws:grafana:...:workspace/...`).

#### 3. WorkspaceURL

Validates that the workspace URL is non-empty and contains `.grafana.net`.

## Running Tests

```bash
# Run from module root
make test

# Run tests directly
cd tests/basic
go test -v -timeout 60m ./...
```

## Infrastructure Created

- Amazon Managed Grafana workspace with AWS SSO authentication
- SERVICE_MANAGED permissions
- Data sources: OpenSearch, CloudWatch, X-Ray
