package common_test

import (
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestTerraformValidate runs 'terraform validate' on all examples
func TestTerraformValidate(t *testing.T) {
	examples := []string{"basic"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Use InitTerraform to create terraform options without running apply
			terraformOptions := testctx.InitTerraform("../../examples/"+example, testctx.TestConfig{
				Name: "validate-test-" + example,
			})

			terraform.Init(t, terraformOptions)
			terraform.Validate(t, terraformOptions)
		})
	}
}

// TestRequiredOutputs checks that required outputs are defined in plan
func TestRequiredOutputs(t *testing.T) {
	examples := []string{"basic"}
	requiredOutputs := []string{"anomaly_monitor_arn", "anomaly_monitor_name"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			terraformOptions := testctx.InitTerraform("../../examples/"+example, testctx.TestConfig{
				Name: "outputs-test-" + example,
			})

			terraform.Init(t, terraformOptions)
			plan := terraform.Plan(t, terraformOptions)

			for _, output := range requiredOutputs {
				assert.Contains(t, plan, output, "Required output '%s' should be defined in plan", output)
			}
		})
	}
}

// TestCostAnomalyResources checks that the cost anomaly resources are planned
func TestCostAnomalyResources(t *testing.T) {
	examples := []string{"basic"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			terraformOptions := testctx.InitTerraform("../../examples/"+example, testctx.TestConfig{
				Name: "resources-test-" + example,
			})

			terraform.Init(t, terraformOptions)
			plan := terraform.Plan(t, terraformOptions)

			// Verify that the anomaly monitor resource is planned
			assert.Contains(t, plan, "aws_ce_anomaly_monitor.this", "Anomaly monitor resource should be planned")
			assert.Contains(t, plan, "anomaly_monitor_arn", "Monitor ARN output should be planned")
			assert.Contains(t, plan, "anomaly_monitor_name", "Monitor name output should be planned")
		})
	}
}

// TestInputsMatchPlanned verifies that inputs are correctly planned
func TestInputsMatchPlanned(t *testing.T) {
	examples := []string{"basic"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			terraformOptions := testctx.InitTerraform("../../examples/"+example, testctx.TestConfig{
				Name: "inputs-test-" + example,
			})

			terraform.Init(t, terraformOptions)
			plan := terraform.Plan(t, terraformOptions)

			// Verify monitor configuration is planned correctly
			assert.Contains(t, plan, "monitor_type      = \"DIMENSIONAL\"", "Monitor type should be DIMENSIONAL")
			assert.Contains(t, plan, "monitor_dimension = \"SERVICE\"", "Monitor dimension should be SERVICE")
		})
	}
}
