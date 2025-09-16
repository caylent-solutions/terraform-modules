package basic_test

import (
	"path/filepath"
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestTerraformFormat checks if the Terraform code is properly formatted
// This test ensures that the Terraform code follows consistent formatting
func TestTerraformFormat(t *testing.T) {
	examplesRoot := "../../examples"
	examples := []string{"basic"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			examplePath := filepath.Join(examplesRoot, example)

			// Run the example
			ctx := testctx.Run(examplePath, testctx.TestConfig{
				Name: "format-test-" + example,
			})

			// Check if terraform code is formatted
			output, err := terraform.RunTerraformCommandE(t, ctx.Terraform, "fmt", "-check", "-recursive")
			assert.Empty(t, output, "Terraform code should be properly formatted")
			assert.NoError(t, err, "Terraform fmt should not fail")
		})
	}
}

// TestTerraformValidate runs 'terraform validate' on all examples
// This test ensures that the Terraform code is syntactically valid
func TestTerraformValidate(t *testing.T) {
	examplesRoot := "../../examples"
	examples := []string{"basic"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			examplePath := filepath.Join(examplesRoot, example)

			// Run the example
			ctx := testctx.Run(examplePath, testctx.TestConfig{
				Name: "validate-test-" + example,
			})

			// Run terraform validate
			terraform.InitAndValidate(t, ctx.Terraform)
		})
	}
}
