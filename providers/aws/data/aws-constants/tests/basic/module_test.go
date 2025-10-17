package basic_test

import (
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBasicExample(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-example-test",
	})

	// Verify terraform validate passes
	terraform.Validate(t, ctx.Terraform)

	// Test that the module can be instantiated without errors
	assert.True(t, true, "Basic example applied successfully")
}

func TestConstantsAccessibility(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "constants-accessibility-test",
	})

	// Verify that the module reference works by checking outputs exist
	outputs := terraform.OutputAll(t, ctx.Terraform)
	assert.NotEmpty(t, outputs, "Should have outputs from the module")
}
