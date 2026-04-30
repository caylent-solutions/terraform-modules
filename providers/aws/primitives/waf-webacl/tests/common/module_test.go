package common_test

import (
	"fmt"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-modules/providers/aws/primitives/waf-webacl/tests/helpers"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestTerraformValidateAllExamples runs terraform validate on all examples.
func TestTerraformValidateAllExamples(t *testing.T) {
	t.Parallel()

	examples := []string{"basic", "advanced"}

	for _, example := range examples {
		example := example
		t.Run(example, func(t *testing.T) {
			t.Parallel()

			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: fmt.Sprintf("common-validate-%s-%d", example, time.Now().Unix()),
			})

			validateOptions := &terraform.Options{
				TerraformDir: ctx.Terraform.TerraformDir,
			}
			terraform.Validate(t, validateOptions)
		})
	}
}

// TestWebACLArnPresentInAllExamples verifies web_acl_arn output is present in all examples.
func TestWebACLArnPresentInAllExamples(t *testing.T) {
	t.Parallel()

	examples := []string{"basic", "advanced"}

	for _, example := range examples {
		example := example
		t.Run(example, func(t *testing.T) {
			t.Parallel()

			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: fmt.Sprintf("common-arn-%s-%d", example, time.Now().Unix()),
			})

			helpers.AssertWebACLArnFormat(t, ctx.Terraform, "web_acl_arn")
		})
	}
}

// TestWebACLNamePresentInAllExamples verifies web_acl_name output is non-empty in all examples.
func TestWebACLNamePresentInAllExamples(t *testing.T) {
	t.Parallel()

	examples := []string{"basic", "advanced"}

	for _, example := range examples {
		example := example
		t.Run(example, func(t *testing.T) {
			t.Parallel()

			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: fmt.Sprintf("common-name-%s-%d", example, time.Now().Unix()),
			})

			webAclName := terraform.Output(t, ctx.Terraform, "web_acl_name")
			assert.NotEmpty(t, webAclName, "web_acl_name must not be empty in example '%s'", example)
		})
	}
}
