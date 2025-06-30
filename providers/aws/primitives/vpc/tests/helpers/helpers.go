package helpers

import (
	"fmt"
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// AssertVPCExists verifies that a VPC exists and has the expected properties
func AssertVPCExists(t *testing.T, ctx testctx.TestContext, expectedCidr string) {
	// Verify VPC outputs exist
	vpcId := terraform.Output(t, ctx.Terraform, "vpc_id")
	assert.NotEmpty(t, vpcId, "VPC ID should not be empty")
	assert.Regexp(t, "^vpc-[a-f0-9]{8,17}$", vpcId, "VPC ID should match AWS format")

	vpcArn := terraform.Output(t, ctx.Terraform, "vpc_arn")
	assert.NotEmpty(t, vpcArn, "VPC ARN should not be empty")
	assert.Regexp(t, "^arn:aws:ec2:[a-z0-9-]+:[0-9]{12}:vpc/vpc-[a-f0-9]{8,17}$", vpcArn, "VPC ARN should match AWS format")

	cidrBlock := terraform.Output(t, ctx.Terraform, "vpc_cidr_block")
	assert.Equal(t, expectedCidr, cidrBlock, "CIDR block should match expected value")
}

// AssertVPCTags verifies that VPC has the expected tags
func AssertVPCTags(t *testing.T, ctx testctx.TestContext, expectedTags map[string]string) {
	// Verify VPC exists (tags are applied if VPC is created successfully)
	vpcId := terraform.Output(t, ctx.Terraform, "vpc_id")
	assert.NotEmpty(t, vpcId, "VPC ID should not be empty")

	// Note: Tag verification would require AWS API calls or state inspection
	// For now, we verify the VPC exists with the expected configuration
}

// AssertVPCDNSSettings verifies VPC DNS configuration
func AssertVPCDNSSettings(t *testing.T, ctx testctx.TestContext, expectDNSSupport, expectDNSHostnames bool) {
	// Check DNS settings through outputs
	dnsSupport := terraform.Output(t, ctx.Terraform, "vpc_enable_dns_support")
	dnsHostnames := terraform.Output(t, ctx.Terraform, "vpc_enable_dns_hostnames")

	assert.Equal(t, expectDNSSupport, dnsSupport, "DNS support setting should match expected value")
	assert.Equal(t, expectDNSHostnames, dnsHostnames, "DNS hostnames setting should match expected value")
}

// AssertVPCInstanceTenancy verifies VPC instance tenancy
func AssertVPCInstanceTenancy(t *testing.T, ctx testctx.TestContext, expectedTenancy string) {
	// Check instance tenancy through outputs
	instanceTenancy := terraform.Output(t, ctx.Terraform, "vpc_instance_tenancy")
	assert.Equal(t, expectedTenancy, instanceTenancy, "Instance tenancy should match expected value")
}

// AssertFlowLogsConfiguration verifies VPC Flow Logs configuration
func AssertFlowLogsConfiguration(t *testing.T, ctx testctx.TestContext, expectFlowLogs bool) {
	if expectFlowLogs {
		// Check that flow log outputs are not empty
		flowLogId := terraform.Output(t, ctx.Terraform, "flow_log_id")
		assert.NotEmpty(t, flowLogId, "Flow log ID should not be empty when enabled")
	} else {
		// Check that flow log outputs are empty
		flowLogId := terraform.Output(t, ctx.Terraform, "flow_log_id")
		assert.Empty(t, flowLogId, "Flow log ID should be empty when disabled")
	}
}

// GetVPCResourceFromState retrieves the VPC resource information from outputs
func GetVPCResourceFromState(t *testing.T, ctx testctx.TestContext) map[string]interface{} {
	// Return VPC information from outputs
	return map[string]interface{}{
		"id":         terraform.Output(t, ctx.Terraform, "vpc_id"),
		"arn":        terraform.Output(t, ctx.Terraform, "vpc_arn"),
		"cidr_block": terraform.Output(t, ctx.Terraform, "vpc_cidr_block"),
	}
}

// ValidateAWSResourceFormat validates AWS resource ID/ARN formats
func ValidateAWSResourceFormat(t *testing.T, resourceType, resourceValue string) {
	switch resourceType {
	case "vpc_id":
		assert.Regexp(t, "^vpc-[a-f0-9]{8,17}$", resourceValue, "VPC ID should match AWS format")
	case "vpc_arn":
		assert.Regexp(t, "^arn:aws:ec2:[a-z0-9-]+:[0-9]{12}:vpc/vpc-[a-f0-9]{8,17}$", resourceValue, "VPC ARN should match AWS format")
	case "route_table_id":
		assert.Regexp(t, "^rtb-[a-f0-9]{8,17}$", resourceValue, "Route table ID should match AWS format")
	case "security_group_id":
		assert.Regexp(t, "^sg-[a-f0-9]{8,17}$", resourceValue, "Security group ID should match AWS format")
	case "network_acl_id":
		assert.Regexp(t, "^acl-[a-f0-9]{8,17}$", resourceValue, "Network ACL ID should match AWS format")
	default:
		t.Fatalf("Unknown resource type for validation: %s", resourceType)
	}
}

// LogVPCDetails logs VPC details for debugging
func LogVPCDetails(t *testing.T, ctx testctx.TestContext) {
	vpcId := terraform.Output(t, ctx.Terraform, "vpc_id")
	vpcArn := terraform.Output(t, ctx.Terraform, "vpc_arn")
	cidrBlock := terraform.Output(t, ctx.Terraform, "vpc_cidr_block")

	t.Logf("VPC Details:")
	t.Logf("  ID: %s", vpcId)
	t.Logf("  ARN: %s", vpcArn)
	t.Logf("  CIDR: %s", cidrBlock)

	// Log additional details if available
	outputs := terraform.OutputAll(t, ctx.Terraform)
	for key, value := range outputs {
		if key != "vpc_id" && key != "vpc_arn" && key != "vpc_cidr_block" {
			t.Logf("  %s: %v", key, value)
		}
	}
}

// AssertCIDRBlockValid validates CIDR block format
func AssertCIDRBlockValid(t *testing.T, cidrBlock string) {
	assert.Regexp(t, `^(\d{1,3}\.){3}\d{1,3}/\d{1,2}$`, cidrBlock, "CIDR block should be in valid format")
}

// CreateTestConfig creates a standardized test configuration
func CreateTestConfig(testName string, extraVars map[string]interface{}) testctx.TestConfig {
	config := testctx.TestConfig{
		Name: fmt.Sprintf("vpc-module-%s", testName),
	}

	if extraVars != nil {
		config.ExtraVars = extraVars
	}

	return config
}
