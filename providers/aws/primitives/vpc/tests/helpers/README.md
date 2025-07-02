# Test Helpers

This directory contains helper functions for VPC module tests.

## Helper Functions

### AssertVPCExists
- Verifies that a VPC exists and has expected properties
- Validates VPC ID and ARN formats
- Checks CIDR block matches expected value

### AssertVPCTags
- Verifies that VPC has expected tags
- Checks both user-provided and module-generated tags
- Validates tag inheritance and merging

### AssertVPCDNSSettings
- Verifies VPC DNS configuration
- Checks DNS support and DNS hostnames settings
- Validates DNS-related functionality

### AssertVPCInstanceTenancy
- Verifies VPC instance tenancy setting
- Ensures tenancy configuration is applied correctly

### AssertFlowLogsConfiguration
- Verifies VPC Flow Logs configuration
- Checks conditional resource creation
- Validates flow logs are created/not created as expected

### GetVPCResourceFromState
- Retrieves VPC resource from Terraform state
- Provides access to all VPC attributes for detailed testing

### ValidateAWSResourceFormat
- Validates AWS resource ID/ARN formats
- Supports multiple AWS resource types
- Ensures resources follow AWS naming conventions

### LogVPCDetails
- Logs VPC details for debugging
- Helpful for troubleshooting test failures
- Provides comprehensive VPC information

### AssertCIDRBlockValid
- Validates CIDR block format
- Ensures CIDR blocks are properly formatted

### CreateTestConfig
- Creates standardized test configurations
- Provides consistent test setup
- Supports additional variables for customization

## Usage

Import the helpers package in your test files:

```go
import "path/to/tests/helpers"

// Use helper functions in tests
helpers.AssertVPCExists(t, ctx, "10.0.0.0/16")
helpers.AssertVPCTags(t, ctx, map[string]string{
    "Environment": "test",
    "Purpose": "testing",
})
```

## Benefits

- Reduces code duplication across test files
- Provides consistent validation logic
- Makes tests more readable and maintainable
- Enables reusable test patterns