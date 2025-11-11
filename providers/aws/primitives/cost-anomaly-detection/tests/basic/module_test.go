package basic_test

import (
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestBasicValidation tests the basic functionality of the module
// It verifies that the configuration is valid and can be planned
func TestBasicValidation(t *testing.T) {
	terraformOptions := testctx.InitTerraform("../../examples/basic", testctx.TestConfig{
		Name: "basic-validation",
	})

	terraform.Init(t, terraformOptions)
	terraform.Validate(t, terraformOptions)
	plan := terraform.Plan(t, terraformOptions)

	// Verify that the plan contains expected resources
	assert.Contains(t, plan, "aws_ce_anomaly_monitor.this", "Plan should include anomaly monitor")
	assert.Contains(t, plan, "anomaly_monitor_arn", "Plan should include monitor ARN output")
	assert.Contains(t, plan, "anomaly_monitor_name", "Plan should include monitor name output")
}

// TestBasicConfiguration verifies the basic configuration parameters
func TestBasicConfiguration(t *testing.T) {
	terraformOptions := testctx.InitTerraform("../../examples/basic", testctx.TestConfig{
		Name: "basic-config-test",
	})

	terraform.Init(t, terraformOptions)
	plan := terraform.Plan(t, terraformOptions)

	// Verify basic configuration is correct
	assert.Contains(t, plan, "monitor_type      = \"DIMENSIONAL\"", "Monitor should be DIMENSIONAL type")
	assert.Contains(t, plan, "monitor_dimension = \"SERVICE\"", "Monitor should use SERVICE dimension")
	assert.Contains(t, plan, "basic-cost-anomaly-detector-monitor", "Monitor should have expected name")
}

// TestBasicOutputs verifies that the basic example defines required outputs
func TestBasicOutputs(t *testing.T) {
	terraformOptions := testctx.InitTerraform("../../examples/basic", testctx.TestConfig{
		Name: "basic-outputs-test",
	})

	terraform.Init(t, terraformOptions)
	plan := terraform.Plan(t, terraformOptions)

	// Verify outputs are defined in the plan
	assert.Contains(t, plan, "anomaly_monitor_arn", "Should define monitor ARN output")
	assert.Contains(t, plan, "anomaly_monitor_name", "Should define monitor name output")
	assert.Contains(t, plan, "anomaly_subscription_arn", "Should define subscription ARN output")
	assert.Contains(t, plan, "anomaly_subscription_name", "Should define subscription name output")
}
