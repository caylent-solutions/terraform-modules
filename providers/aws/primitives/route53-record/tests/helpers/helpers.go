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

// AssertRoute53RecordExists verifies that a Route53 record output is not empty
func AssertRoute53RecordExists(t *testing.T, ctx testctx.TestContext) {
	recordName := terraform.Output(t, ctx.Terraform, "record_name")
	assert.NotEmpty(t, recordName, "record_name should not be empty")

	recordFQDN := terraform.Output(t, ctx.Terraform, "record_fqdn")
	assert.NotEmpty(t, recordFQDN, "record_fqdn should not be empty")
}

// AssertRecordType verifies the record type output matches the expected value
func AssertRecordType(t *testing.T, ctx testctx.TestContext, expectedType string) {
	recordType := terraform.Output(t, ctx.Terraform, "record_type")
	assert.Equal(t, expectedType, recordType, "record_type should match expected value")
}

// AssertRecordTTL verifies the record TTL output matches the expected value
func AssertRecordTTL(t *testing.T, ctx testctx.TestContext, expectedTTL string) {
	recordTTL := terraform.Output(t, ctx.Terraform, "record_ttl")
	assert.Equal(t, expectedTTL, recordTTL, "record_ttl should match expected value")
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
