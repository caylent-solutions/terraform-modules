package basic_test

import (
	"path/filepath"
	"testing"

	_ "github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformFormat(t *testing.T) {
	examples := []string{"basic"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			exampleDir := filepath.Join("../../examples", example)
			terraformOptions := &terraform.Options{
				TerraformDir: exampleDir,
				NoColor:      true,
			}

			output, err := terraform.RunTerraformCommandE(t, terraformOptions, "fmt", "-check", "-recursive")
			assert.Empty(t, output, "Terraform code should be properly formatted")
			assert.NoError(t, err, "Terraform fmt should not fail")
		})
	}
}

func TestTerraformValidate(t *testing.T) {
	examples := []string{"basic"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			exampleDir := filepath.Join("../../examples", example)
			terraformOptions := &terraform.Options{
				TerraformDir: exampleDir,
				NoColor:      true,
			}

			terraform.Init(t, terraformOptions)
			terraform.Validate(t, terraformOptions)
		})
	}
}
