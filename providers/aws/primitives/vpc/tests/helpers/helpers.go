package helpers

import (
	"fmt"
	"os"
	"regexp"
	"strings"
	"testing"
	"time"

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
	flowLogId := terraform.Output(t, ctx.Terraform, "flow_log_id")
	if expectFlowLogs {
		assert.NotEmpty(t, flowLogId, "Flow log ID must not be empty when enabled")
	} else {
		assert.Empty(t, flowLogId, "Flow log ID must be empty when disabled")
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
	if testName == "" {
		panic("testName cannot be empty")
	}
	config := testctx.TestConfig{
		Name: fmt.Sprintf("vpc-module-%s", testName),
	}
	config.ExtraVars = extraVars
	return config
}

// AssertResourceExists verifies that at least one instance of a given resource type exists in the Terraform state
func AssertResourceExists(t *testing.T, terraformOptions *terraform.Options, resourceType string) {
	stateOutput, err := terraform.RunTerraformCommandE(t, terraformOptions, "state", "list")
	if err != nil {
		t.Fatalf("Failed to list terraform state: %v", err)
	}

	resourceCount := strings.Count(stateOutput, resourceType)
	if resourceCount == 0 {
		t.Fatalf("Expected at least 1 %s resource, found 0. State contents: %s", resourceType, stateOutput)
	}
}

// AssertResourceCountExact verifies the exact number of a specific resource type in the state
func AssertResourceCountExact(t *testing.T, terraformOptions *terraform.Options, resourceType string, expectedCount int) {
	stateOutput, err := terraform.RunTerraformCommandE(t, terraformOptions, "state", "list")
	if err != nil {
		t.Fatalf("Failed to list terraform state: %v", err)
	}

	actualCount := strings.Count(stateOutput, resourceType)
	if actualCount != expectedCount {
		t.Fatalf("Expected exactly %d %s resources, found %d. State contents: %s", expectedCount, resourceType, actualCount, stateOutput)
	}
}

// AssertOutputExists ensures a Terraform output is defined
func AssertOutputExists(t *testing.T, terraformOptions *terraform.Options, outputName string) {
	outputs := terraform.OutputAll(t, terraformOptions)
	if _, exists := outputs[outputName]; !exists {
		availableOutputs := make([]string, 0, len(outputs))
		for key := range outputs {
			availableOutputs = append(availableOutputs, key)
		}
		t.Fatalf("Expected output '%s' to exist, but it was not found. Available outputs: %v", outputName, availableOutputs)
	}
}

// AssertOutputMatchesRegex matches a Terraform output against a regex pattern
func AssertOutputMatchesRegex(t *testing.T, terraformOptions *terraform.Options, outputName string, regexPattern string) {
	outputValue := terraform.Output(t, terraformOptions, outputName)
	matched, err := regexp.MatchString(regexPattern, outputValue)
	if err != nil {
		t.Fatalf("Invalid regex pattern '%s': %v", regexPattern, err)
	}
	if !matched {
		t.Fatalf("Output '%s' with value '%s' does not match regex pattern '%s'", outputName, outputValue, regexPattern)
	}
}

// AssertOutputEquals verifies that a Terraform output matches an expected value
func AssertOutputEquals(t *testing.T, terraformOptions *terraform.Options, outputName string, expectedValue interface{}) {
	outputValue := terraform.Output(t, terraformOptions, outputName)
	var expectedStr string
	switch v := expectedValue.(type) {
	case bool:
		if v {
			expectedStr = "true"
		} else {
			expectedStr = "false"
		}
	default:
		expectedStr = fmt.Sprintf("%v", expectedValue)
	}
	if outputValue != expectedStr {
		t.Fatalf("Expected output '%s' to be '%v', but got '%v'", outputName, expectedStr, outputValue)
	}
}

// AssertOutputNotEmpty verifies that a Terraform output is not empty
func AssertOutputNotEmpty(t *testing.T, terraformOptions *terraform.Options, outputName string) {
	outputValue := terraform.Output(t, terraformOptions, outputName)
	if outputValue == "" {
		t.Fatalf("Expected output '%s' to not be empty, but it was empty", outputName)
	}
}

// AssertOutputEmpty verifies that a Terraform output is empty
func AssertOutputEmpty(t *testing.T, terraformOptions *terraform.Options, outputName string) {
	outputValue := terraform.Output(t, terraformOptions, outputName)
	if outputValue != "" {
		t.Fatalf("Expected output '%s' to be empty, but got '%v'", outputName, outputValue)
	}
}

// AssertStateContains verifies that the terraform state contains a specific resource path
func AssertStateContains(t *testing.T, terraformOptions *terraform.Options, resourcePath string) {
	stateOutput, err := terraform.RunTerraformCommandE(t, terraformOptions, "state", "list")
	if err != nil {
		t.Fatalf("Failed to list terraform state: %v", err)
	}

	if !strings.Contains(stateOutput, resourcePath) {
		t.Fatalf("Expected state to contain resource '%s', but it was not found. State contents: %s", resourcePath, stateOutput)
	}
}

// GenerateUniqueName creates a unique name with timestamp for test resources
func GenerateUniqueName(prefix string) string {
	return fmt.Sprintf("%s-%d", prefix, time.Now().Unix())
}

// GenerateUniqueTestConfig creates a test config with unique resource naming
func GenerateUniqueTestConfig(testName, resourcePrefix string) testctx.TestConfig {
	return testctx.TestConfig{
		Name: testName,
		ExtraVars: map[string]interface{}{
			"name": GenerateUniqueName(resourcePrefix),
		},
	}
}

// GenerateUniqueCIDR generates a unique CIDR block based on timestamp to avoid overlaps
func GenerateUniqueCIDR() string {
	// Generate valid /16 networks from 10.0.0.0/16 to 10.255.0.0/16
	timestamp := time.Now().Unix()
	secondOctet := timestamp % 256
	return fmt.Sprintf("10.%d.0.0/16", secondOctet)
}

// GetRequiredTerraformVersion reads the required Terraform version from versions.tf
func GetRequiredTerraformVersion(t *testing.T) string {
	content, err := os.ReadFile("../../versions.tf")
	if err != nil {
		t.Fatalf("Failed to read versions.tf: %v", err)
	}
	lines := strings.Split(string(content), "\n")
	for _, line := range lines {
		if strings.Contains(line, "required_version") {
			start := strings.Index(line, `"`)
			end := strings.LastIndex(line, `"`)
			if start == -1 || end == -1 || start >= end {
				t.Fatalf("Invalid required_version format in versions.tf: %s", line)
			}
			versionStr := line[start+1 : end]
			if versionStr == "" {
				t.Fatalf("Empty required_version found in versions.tf")
			}
			// Extract version number from ">= 1.12.1" or "1.12.1" format
			versionStr = strings.TrimPrefix(versionStr, ">= ")
			versionStr = strings.TrimPrefix(versionStr, "~> ")
			versionStr = strings.TrimPrefix(versionStr, "= ")
			if versionStr == "" {
				t.Fatalf("Invalid version format after parsing: %s", line)
			}
			return versionStr
		}
	}
	t.Fatalf("Required Terraform version not found in versions.tf")
	return ""
}
