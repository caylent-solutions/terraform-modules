package basic_test

import (
	"fmt"
	"os"
	"regexp"
	"strings"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// assertOutputNotEmpty verifies that a Terraform output is not empty
func assertOutputNotEmpty(t *testing.T, terraformOptions *terraform.Options, outputName string) {
	t.Helper()
	outputValue := terraform.Output(t, terraformOptions, outputName)
	if outputValue == "" {
		t.Fatalf("Expected output '%s' to not be empty, but it was empty", outputName)
	}
}

// assertOutputMatchesRegex matches a Terraform output against a regex pattern
func assertOutputMatchesRegex(t *testing.T, terraformOptions *terraform.Options, outputName string, regexPattern string) {
	t.Helper()
	outputValue := terraform.Output(t, terraformOptions, outputName)
	matched, err := regexp.MatchString(regexPattern, outputValue)
	if err != nil {
		t.Fatalf("Invalid regex pattern '%s': %v", regexPattern, err)
	}
	if !matched {
		t.Fatalf("Output '%s' with value '%s' does not match regex pattern '%s'", outputName, outputValue, regexPattern)
	}
}

// assertResourceCountExact verifies the exact number of a specific resource type in the state
func assertResourceCountExact(t *testing.T, terraformOptions *terraform.Options, resourceType string, expectedCount int) {
	t.Helper()
	stateOutput, err := terraform.RunTerraformCommandE(t, terraformOptions, "state", "list")
	if err != nil {
		t.Fatalf("Failed to list terraform state: %v", err)
	}

	actualCount := strings.Count(stateOutput, resourceType)
	if actualCount != expectedCount {
		t.Fatalf("Expected exactly %d %s resources, found %d. State contents: %s", expectedCount, resourceType, actualCount, stateOutput)
	}
}

// assertStateContains verifies that the terraform state contains a specific resource path
func assertStateContains(t *testing.T, terraformOptions *terraform.Options, resourcePath string) {
	t.Helper()
	stateOutput, err := terraform.RunTerraformCommandE(t, terraformOptions, "state", "list")
	if err != nil {
		t.Fatalf("Failed to list terraform state: %v", err)
	}

	if !strings.Contains(stateOutput, resourcePath) {
		t.Fatalf("Expected state to contain resource '%s', but it was not found. State contents: %s", resourcePath, stateOutput)
	}
}

// getRequiredTerraformVersion reads the required Terraform version from versions.tf
func getRequiredTerraformVersion(t *testing.T) string {
	t.Helper()
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

// TestBasicAppConfigApplication verifies that the AppConfig application is created with expected properties
func TestBasicAppConfigApplication(t *testing.T) {
	t.Parallel()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-appconfig-app-test",
		ExtraVars: map[string]interface{}{
			"name":                       fmt.Sprintf("test-app-%d", time.Now().Unix()),
			"environment_name":           "test",
			"configuration_profile_name": fmt.Sprintf("fp-%d", time.Now().Unix()),
			"deployment_strategy_name":   fmt.Sprintf("ds-%d", time.Now().Unix()),
		},
	})

	assertOutputNotEmpty(t, ctx.Terraform, "application_id")
	assertOutputNotEmpty(t, ctx.Terraform, "application_arn")
	assertOutputNotEmpty(t, ctx.Terraform, "application_name")
	assertOutputMatchesRegex(t, ctx.Terraform, "application_arn",
		`^arn:aws:appconfig:[a-z0-9-]+:[0-9]{12}:application/[a-z0-9]+$`)
}

// TestBasicAppConfigEnvironment verifies that the AppConfig environment is created correctly
func TestBasicAppConfigEnvironment(t *testing.T) {
	t.Parallel()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-appconfig-env-test",
		ExtraVars: map[string]interface{}{
			"name":                       fmt.Sprintf("test-app-%d", time.Now().Unix()),
			"environment_name":           fmt.Sprintf("test-env-%d", time.Now().Unix()),
			"configuration_profile_name": fmt.Sprintf("fp-%d", time.Now().Unix()),
			"deployment_strategy_name":   fmt.Sprintf("ds-%d", time.Now().Unix()),
		},
	})

	assertOutputNotEmpty(t, ctx.Terraform, "environment_id")
	assertOutputNotEmpty(t, ctx.Terraform, "environment_arn")
	assertOutputNotEmpty(t, ctx.Terraform, "environment_name")
	assertOutputMatchesRegex(t, ctx.Terraform, "environment_arn",
		`^arn:aws:appconfig:[a-z0-9-]+:[0-9]{12}:application/[a-z0-9]+/environment/[a-z0-9]+$`)
}

// TestBasicAppConfigConfigurationProfile verifies that the configuration profile is created correctly
func TestBasicAppConfigConfigurationProfile(t *testing.T) {
	t.Parallel()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-appconfig-profile-test",
		ExtraVars: map[string]interface{}{
			"name":                       fmt.Sprintf("test-app-%d", time.Now().Unix()),
			"environment_name":           "test",
			"configuration_profile_name": fmt.Sprintf("fp-%d", time.Now().Unix()),
			"deployment_strategy_name":   fmt.Sprintf("ds-%d", time.Now().Unix()),
		},
	})

	assertOutputNotEmpty(t, ctx.Terraform, "configuration_profile_id")
	assertOutputNotEmpty(t, ctx.Terraform, "configuration_profile_arn")
	assertOutputNotEmpty(t, ctx.Terraform, "configuration_profile_name")
	assertOutputMatchesRegex(t, ctx.Terraform, "configuration_profile_arn",
		`^arn:aws:appconfig:[a-z0-9-]+:[0-9]{12}:application/[a-z0-9]+/configurationprofile/[a-z0-9]+$`)
}

// TestBasicAppConfigDeploymentStrategy verifies the deployment strategy is created with correct settings
func TestBasicAppConfigDeploymentStrategy(t *testing.T) {
	t.Parallel()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-appconfig-strategy-test",
		ExtraVars: map[string]interface{}{
			"name":                       fmt.Sprintf("test-app-%d", time.Now().Unix()),
			"environment_name":           "test",
			"configuration_profile_name": fmt.Sprintf("fp-%d", time.Now().Unix()),
			"deployment_strategy_name":   fmt.Sprintf("ds-%d", time.Now().Unix()),
		},
	})

	assertOutputNotEmpty(t, ctx.Terraform, "deployment_strategy_id")
	assertOutputNotEmpty(t, ctx.Terraform, "deployment_strategy_arn")
	assertOutputNotEmpty(t, ctx.Terraform, "deployment_strategy_name")
	assertOutputMatchesRegex(t, ctx.Terraform, "deployment_strategy_arn",
		`^arn:aws:appconfig:[a-z0-9-]+:[0-9]{12}:deploymentstrategy/[a-z0-9]+$`)
}

// TestBasicAppConfigResourceCounts verifies expected resource counts are created
func TestBasicAppConfigResourceCounts(t *testing.T) {
	t.Parallel()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-appconfig-counts-test",
		ExtraVars: map[string]interface{}{
			"name":                       fmt.Sprintf("test-app-%d", time.Now().Unix()),
			"environment_name":           "test",
			"configuration_profile_name": fmt.Sprintf("fp-%d", time.Now().Unix()),
			"deployment_strategy_name":   fmt.Sprintf("ds-%d", time.Now().Unix()),
		},
	})

	assertResourceCountExact(t, ctx.Terraform, "aws_appconfig_application", 1)
	assertResourceCountExact(t, ctx.Terraform, "aws_appconfig_environment", 1)
	assertResourceCountExact(t, ctx.Terraform, "aws_appconfig_configuration_profile", 1)
	assertResourceCountExact(t, ctx.Terraform, "aws_appconfig_deployment_strategy", 1)
}

// TestBasicAppConfigStateContents verifies resources are in Terraform state
func TestBasicAppConfigStateContents(t *testing.T) {
	t.Parallel()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-appconfig-state-test",
		ExtraVars: map[string]interface{}{
			"name":                       fmt.Sprintf("test-app-%d", time.Now().Unix()),
			"environment_name":           "test",
			"configuration_profile_name": fmt.Sprintf("fp-%d", time.Now().Unix()),
			"deployment_strategy_name":   fmt.Sprintf("ds-%d", time.Now().Unix()),
		},
	})

	assertStateContains(t, ctx.Terraform, "module.appconfig.aws_appconfig_application.this")
	assertStateContains(t, ctx.Terraform, "module.appconfig.aws_appconfig_environment.this")
	assertStateContains(t, ctx.Terraform, "module.appconfig.aws_appconfig_configuration_profile.this")
	assertStateContains(t, ctx.Terraform, "module.appconfig.aws_appconfig_deployment_strategy.this")
}

// TestBasicAppConfigIdempotency tests idempotency of the module
func TestBasicAppConfigIdempotency(t *testing.T) {
	t.Parallel()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-appconfig-idempotency-test",
		ExtraVars: map[string]interface{}{
			"name":                       fmt.Sprintf("test-app-%d", time.Now().Unix()),
			"environment_name":           "test",
			"configuration_profile_name": fmt.Sprintf("fp-%d", time.Now().Unix()),
			"deployment_strategy_name":   fmt.Sprintf("ds-%d", time.Now().Unix()),
		},
	})

	assertions.AssertIdempotent(t, ctx)
}

// TestBasicAppConfigTerraformValidate runs terraform validate on the basic example
func TestBasicAppConfigTerraformValidate(t *testing.T) {
	t.Parallel()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-appconfig-validate-test",
		ExtraVars: map[string]interface{}{
			"name":                       fmt.Sprintf("test-app-%d", time.Now().Unix()),
			"environment_name":           "test",
			"configuration_profile_name": fmt.Sprintf("fp-%d", time.Now().Unix()),
			"deployment_strategy_name":   fmt.Sprintf("ds-%d", time.Now().Unix()),
		},
	})

	validateOptions := &terraform.Options{
		TerraformDir: ctx.Terraform.TerraformDir,
	}
	terraform.Validate(t, validateOptions)
}

// TestBasicAppConfigTerraformVersion verifies minimum Terraform version requirement
func TestBasicAppConfigTerraformVersion(t *testing.T) {
	t.Parallel()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-appconfig-version-test",
		ExtraVars: map[string]interface{}{
			"name":                       fmt.Sprintf("test-app-%d", time.Now().Unix()),
			"environment_name":           "test",
			"configuration_profile_name": fmt.Sprintf("fp-%d", time.Now().Unix()),
			"deployment_strategy_name":   fmt.Sprintf("ds-%d", time.Now().Unix()),
		},
	})

	minVersion := getRequiredTerraformVersion(t)
	assertions.AssertTerraformVersion(t, ctx, minVersion)
}
