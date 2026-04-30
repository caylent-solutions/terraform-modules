package basic_test

import (
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// uniqueName creates a unique resource name with a timestamp suffix.
func uniqueName(prefix string) string {
	return fmt.Sprintf("%s-%d", prefix, time.Now().Unix())
}

// baseVars returns the minimum set of required variables for the basic example.
// The access_log_group_name is derived from the API name to keep resource names consistent.
func baseVars(apiName, stageName string) map[string]interface{} {
	return map[string]interface{}{
		"name":                  apiName,
		"stage_name":            stageName,
		"access_log_group_name": fmt.Sprintf("/aws/apigateway/%s/%s", apiName, stageName),
	}
}

// getRequiredTerraformVersion reads the required Terraform version from versions.tf.
func getRequiredTerraformVersion(t *testing.T) string {
	content, err := os.ReadFile("../../versions.tf")
	require.NoError(t, err, "must be able to read versions.tf")
	for _, line := range strings.Split(string(content), "\n") {
		if strings.Contains(line, "required_version") {
			start := strings.Index(line, `"`)
			end := strings.LastIndex(line, `"`)
			require.True(t, start >= 0 && end > start, "required_version must have valid quotes in versions.tf")
			version := line[start+1 : end]
			version = strings.TrimPrefix(version, ">= ")
			version = strings.TrimPrefix(version, "~> ")
			version = strings.TrimPrefix(version, "= ")
			require.NotEmpty(t, version, "required_version must not be empty after parsing")
			return version
		}
	}
	t.Fatal("required_version not found in versions.tf")
	return ""
}

// TestBasicAPICreation verifies that the REST API is created with expected outputs.
func TestBasicAPICreation(t *testing.T) {
	t.Parallel()

	apiName := uniqueName("test-api")
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name:      "basic-api-creation",
		ExtraVars: baseVars(apiName, "v1"),
	})

	restAPIID := terraform.Output(t, ctx.Terraform, "rest_api_id")
	assert.NotEmpty(t, restAPIID, "rest_api_id must not be empty")
	assert.Regexp(t, `^[a-z0-9]{5,10}$`, restAPIID, "rest_api_id must match AWS API Gateway ID format")

	restAPIARN := terraform.Output(t, ctx.Terraform, "rest_api_arn")
	assert.NotEmpty(t, restAPIARN, "rest_api_arn must not be empty")
	assert.Regexp(t, `^arn:aws:apigateway:[a-z0-9-]+::/restapis/[a-z0-9]+$`, restAPIARN, "rest_api_arn must match AWS ARN format")

	rootResourceID := terraform.Output(t, ctx.Terraform, "rest_api_root_resource_id")
	assert.NotEmpty(t, rootResourceID, "rest_api_root_resource_id must not be empty")
}

// TestBasicStageOutputs verifies that the deployment stage outputs are set correctly.
func TestBasicStageOutputs(t *testing.T) {
	t.Parallel()

	apiName := uniqueName("test-api")
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name:      "basic-stage-outputs",
		ExtraVars: baseVars(apiName, "v1"),
	})

	stageID := terraform.Output(t, ctx.Terraform, "stage_id")
	assert.NotEmpty(t, stageID, "stage_id must not be empty")

	stageARN := terraform.Output(t, ctx.Terraform, "stage_arn")
	assert.NotEmpty(t, stageARN, "stage_arn must not be empty")
	assert.Contains(t, stageARN, "arn:aws:apigateway:", "stage_arn must be a valid AWS ARN")

	invokeURL := terraform.Output(t, ctx.Terraform, "stage_invoke_url")
	assert.NotEmpty(t, invokeURL, "stage_invoke_url must not be empty")
	assert.Contains(t, invokeURL, "execute-api", "stage_invoke_url must reference execute-api endpoint")

	executionARN := terraform.Output(t, ctx.Terraform, "stage_execution_arn")
	assert.NotEmpty(t, executionARN, "stage_execution_arn must not be empty")
	assert.Regexp(t, `^arn:aws:execute-api:`, executionARN, "stage_execution_arn must be an execute-api ARN")
}

// TestBasicExecutionARN verifies the execution ARN format for Lambda permission use.
func TestBasicExecutionARN(t *testing.T) {
	t.Parallel()

	apiName := uniqueName("test-api")
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name:      "basic-execution-arn",
		ExtraVars: baseVars(apiName, "v1"),
	})

	execARN := terraform.Output(t, ctx.Terraform, "rest_api_execution_arn")
	assert.NotEmpty(t, execARN, "rest_api_execution_arn must not be empty")
	assert.Regexp(t, `^arn:aws:execute-api:[a-z0-9-]+:[0-9]{12}:[a-z0-9]+$`, execARN, "rest_api_execution_arn must match expected format")
}

// TestBasicAccessLogging verifies that access logging is enabled and the log group ARN is exported.
func TestBasicAccessLogging(t *testing.T) {
	t.Parallel()

	apiName := uniqueName("test-api")
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name:      "basic-access-logging",
		ExtraVars: baseVars(apiName, "v1"),
	})

	logGroupARN := terraform.Output(t, ctx.Terraform, "access_log_group_arn")
	assert.NotEmpty(t, logGroupARN, "access_log_group_arn must not be empty")
	assert.Regexp(t, `^arn:aws:logs:`, logGroupARN, "access_log_group_arn must be a valid CloudWatch log group ARN")
}

// TestBasicResourceCounts verifies that exactly the expected resource types are created.
func TestBasicResourceCounts(t *testing.T) {
	t.Parallel()

	apiName := uniqueName("test-api")
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name:      "basic-resource-counts",
		ExtraVars: baseVars(apiName, "v1"),
	})

	stateOutput, err := terraform.RunTerraformCommandE(t, ctx.Terraform, "state", "list")
	require.NoError(t, err, "terraform state list must succeed")

	apiCount := strings.Count(stateOutput, "aws_api_gateway_rest_api")
	assert.Equal(t, 1, apiCount, "exactly one aws_api_gateway_rest_api must exist")

	stageCount := strings.Count(stateOutput, "aws_api_gateway_stage")
	assert.Equal(t, 1, stageCount, "exactly one aws_api_gateway_stage must exist")

	deploymentCount := strings.Count(stateOutput, "aws_api_gateway_deployment")
	assert.Equal(t, 1, deploymentCount, "exactly one aws_api_gateway_deployment must exist")

	logGroupCount := strings.Count(stateOutput, "aws_cloudwatch_log_group")
	assert.Equal(t, 1, logGroupCount, "exactly one aws_cloudwatch_log_group must exist")

	// No custom domain, WAF, or usage plan created in the basic example
	domainCount := strings.Count(stateOutput, "aws_api_gateway_domain_name")
	assert.Equal(t, 0, domainCount, "no aws_api_gateway_domain_name must exist in the basic example")

	wafCount := strings.Count(stateOutput, "aws_wafv2_web_acl_association")
	assert.Equal(t, 0, wafCount, "no aws_wafv2_web_acl_association must exist in the basic example")

	usagePlanCount := strings.Count(stateOutput, "aws_api_gateway_usage_plan")
	assert.Equal(t, 0, usagePlanCount, "no aws_api_gateway_usage_plan must exist in the basic example")
}

// TestBasicTerraformValidate runs terraform validate on the basic example.
func TestBasicTerraformValidate(t *testing.T) {
	t.Parallel()

	apiName := uniqueName("test-api")
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name:      "basic-validate",
		ExtraVars: baseVars(apiName, "v1"),
	})

	validateOptions := &terraform.Options{
		TerraformDir: ctx.Terraform.TerraformDir,
	}
	terraform.Validate(t, validateOptions)
}

// TestBasicIdempotency verifies that the basic example is idempotent (no changes on second apply).
func TestBasicIdempotency(t *testing.T) {
	t.Parallel()

	apiName := uniqueName("test-api")
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name:      "basic-idempotency",
		ExtraVars: baseVars(apiName, "v1"),
	})

	assertions.AssertIdempotent(t, ctx)
}

// TestBasicTerraformVersion verifies the Terraform version requirement is met.
func TestBasicTerraformVersion(t *testing.T) {
	t.Parallel()

	apiName := uniqueName("test-api")
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name:      "basic-tf-version",
		ExtraVars: baseVars(apiName, "v1"),
	})

	minVersion := getRequiredTerraformVersion(t)
	assertions.AssertTerraformVersion(t, ctx, minVersion)
}

// TestBasicInvalidLoggingLevel verifies that an invalid logging_level value is rejected at plan time.
func TestBasicInvalidLoggingLevel(t *testing.T) {
	t.Parallel()

	apiName := uniqueName("test-api")
	vars := baseVars(apiName, "v1")
	vars["logging_level"] = "VERBOSE"

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/basic",
		Vars:         vars,
		NoColor:      true,
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err, "an invalid logging_level value must cause Terraform plan to fail")
}

// TestBasicInvalidEndpointType verifies that an invalid endpoint_type value is rejected at plan time.
func TestBasicInvalidEndpointType(t *testing.T) {
	t.Parallel()

	apiName := uniqueName("test-api")
	vars := baseVars(apiName, "v1")
	vars["endpoint_type"] = "INVALID_TYPE"

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/basic",
		Vars:         vars,
		NoColor:      true,
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err, "an invalid endpoint_type value must cause Terraform plan to fail")
}
