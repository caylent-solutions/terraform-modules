# Basic VPC Tests

This directory contains tests specific to the basic example that demonstrate standard VPC functionality with fixed CIDR blocks.

## Tests Included

### Basic Example Specific Tests
- **TestBasicVPCConfiguration**: Tests VPC creation with fixed CIDR (10.0.0.0/16)
- **TestBasicVPCTags**: Tests tag application in basic example
- **TestBasicVPCFlowLogs**: Tests flow logs creation when enabled
- **TestBasicVPCNoIPv6**: Verifies IPv6 is not enabled when disabled
- **TestBasicVPCResourceCounts**: Validates basic example resource counts (no IPAM resources)
- **TestBasicVPCFixedCIDR**: Tests fixed CIDR specific functionality
- **TestBasicInputsMatchProvisioned**: Verifies basic example inputs match provisioned resources
- **TestBasicVPCFunctionality**: Tests basic VPC functionality with fixed CIDR
- **TestBasicVPCNetworkAddressUsageMetrics**: Tests network address usage metrics setting

## Key Features Tested

- Fixed CIDR block allocation (10.0.0.0/16)
- Standard VPC creation without IPAM
- Basic flow logs configuration
- Standard DNS settings
- No IPAM resources should be created
- Network address usage metrics
- Tag application on VPC resources

## Running Tests

```bash
# Run basic tests specifically
go test ./tests/basic -v

# Run all tests (includes common and advanced-ipam)
make test

# Run with specific settings
TERRATEST_IDEMPOTENCY=true make test
```

## Test Coverage

These tests verify basic example specific functionality:
- Fixed CIDR block configuration (10.0.0.0/16)
- Standard VPC creation without IPAM pools
- Basic flow logs with CloudWatch integration
- DNS settings (support and hostnames enabled)
- IPv6 disabled configuration
- Network address usage metrics enabled
- Proper tag application
- No IPAM resources created

## Note

Common functionality shared across all examples is tested in the `tests/common` directory. This directory focuses on basic example-specific functionality that differs from the advanced-ipam example.