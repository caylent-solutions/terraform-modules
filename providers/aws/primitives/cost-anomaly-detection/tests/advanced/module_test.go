package advanced_test

import (
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestAdvancedValidation tests the advanced functionality of the module
// It verifies that the configuration is valid and can be planned
func TestAdvancedValidation(t *testing.T) {
	terraformOptions := testctx.InitTerraform("../../examples/advanced", testctx.TestConfig{
		Name: "advanced-validation",
	})

	terraform.Init(t, terraformOptions)
	terraform.Validate(t, terraformOptions)
	plan := terraform.Plan(t, terraformOptions)

	// Verify that the plan contains expected resources
	assert.Contains(t, plan, "aws_ce_anomaly_monitor.this", "Plan should include anomaly monitor")
	assert.Contains(t, plan, "aws_ce_anomaly_subscription.this", "Plan should include anomaly subscription")
	assert.Contains(t, plan, "anomaly_monitor_arn", "Plan should include monitor ARN output")
	assert.Contains(t, plan, "anomaly_subscription_arn", "Plan should include subscription ARN output")
}

// TestAdvancedConfiguration verifies the advanced configuration parameters
func TestAdvancedConfiguration(t *testing.T) {
	terraformOptions := testctx.InitTerraform("../../examples/advanced", testctx.TestConfig{
		Name: "advanced-config-test",
	})

	terraform.Init(t, terraformOptions)
	plan := terraform.Plan(t, terraformOptions)

	// Verify advanced configuration is correct
	assert.Contains(t, plan, "monitor_type      = \"DIMENSIONAL\"", "Monitor should be DIMENSIONAL type")
	assert.Contains(t, plan, "monitor_dimension = \"SERVICE\"", "Monitor should use SERVICE dimension")
	assert.Contains(t, plan, "advanced-cost-anomaly-detector", "Monitor should have expected name prefix")
	assert.Contains(t, plan, "frequency        = \"IMMEDIATE\"", "Subscription should be IMMEDIATE frequency")
}

// TestAdvancedSubscription verifies the subscription configuration in advanced example
func TestAdvancedSubscription(t *testing.T) {
	terraformOptions := testctx.InitTerraform("../../examples/advanced", testctx.TestConfig{
		Name: "advanced-subscription-test",
	})

	terraform.Init(t, terraformOptions)
	plan := terraform.Plan(t, terraformOptions)

	// Verify subscription configuration
	assert.Contains(t, plan, "aws_ce_anomaly_subscription.this", "Plan should include subscription resource")
	assert.Contains(t, plan, "frequency        = \"IMMEDIATE\"", "Subscription should have IMMEDIATE frequency")
	assert.Contains(t, plan, "devops@example.com", "Subscription should include devops email subscriber")
	assert.Contains(t, plan, "finance@example.com", "Subscription should include finance email subscriber")
	assert.Contains(t, plan, "type    = \"EMAIL\"", "Subscriber should be EMAIL type")
}

// TestAdvancedOutputs verifies that the advanced example defines all required outputs
func TestAdvancedOutputs(t *testing.T) {
	terraformOptions := testctx.InitTerraform("../../examples/advanced", testctx.TestConfig{
		Name: "advanced-outputs-test",
	})

	terraform.Init(t, terraformOptions)
	plan := terraform.Plan(t, terraformOptions)

	// Verify all outputs are defined in the plan
	assert.Contains(t, plan, "anomaly_monitor_arn", "Should define monitor ARN output")
	assert.Contains(t, plan, "anomaly_monitor_name", "Should define monitor name output")
	assert.Contains(t, plan, "anomaly_subscription_arn", "Should define subscription ARN output")
	assert.Contains(t, plan, "anomaly_subscription_name", "Should define subscription name output")

	// Verify threshold configuration
	assert.Contains(t, plan, "ANOMALY_TOTAL_IMPACT_ABSOLUTE", "Should configure anomaly threshold")
	assert.Contains(t, plan, "GREATER_THAN_OR_EQUAL", "Should use correct threshold comparison")
}
