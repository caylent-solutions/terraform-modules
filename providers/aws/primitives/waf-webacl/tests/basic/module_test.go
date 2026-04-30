package basic_test

import (
	"fmt"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-modules/providers/aws/primitives/waf-webacl/tests/helpers"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestBasicWebACLCreation verifies that the Web ACL is created with correct properties.
func TestBasicWebACLCreation(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-webacl-creation-%d", time.Now().Unix()),
	})

	helpers.AssertOutputNotEmpty(t, ctx.Terraform, "web_acl_id")
	helpers.AssertWebACLArnFormat(t, ctx.Terraform, "web_acl_arn")
}

// TestBasicWebACLName verifies the Web ACL name output matches the input.
func TestBasicWebACLName(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-webacl-name-%d", time.Now().Unix()),
	})

	webAclName := terraform.Output(t, ctx.Terraform, "web_acl_name")
	assert.NotEmpty(t, webAclName, "web_acl_name must not be empty")
	assert.Equal(t, "telemetry-api-waf-basic", webAclName, "web_acl_name must match terraform.tfvars value")
}

// TestBasicWebACLCapacity verifies that WAF capacity units are reported.
func TestBasicWebACLCapacity(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-webacl-capacity-%d", time.Now().Unix()),
	})

	webAclCapacity := terraform.Output(t, ctx.Terraform, "web_acl_capacity")
	assert.NotEmpty(t, webAclCapacity, "web_acl_capacity must not be empty")

	// Capacity must be a positive integer string
	assert.Regexp(t, `^\d+$`, webAclCapacity, "web_acl_capacity must be a non-negative integer")
}

// TestBasicWebACLResourceCount verifies the correct number of WAF resources in state.
func TestBasicWebACLResourceCount(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-webacl-resource-count-%d", time.Now().Unix()),
	})

	helpers.AssertResourceCountExact(t, ctx.Terraform, "module.waf_webacl.aws_wafv2_web_acl.this", 1)

	// No IP set in basic example (ip_set_rule disabled by default)
	helpers.AssertResourceCountExact(t, ctx.Terraform, "aws_wafv2_ip_set", 0)
}

// TestBasicWebACLRequiredOutputs verifies all expected outputs exist.
func TestBasicWebACLRequiredOutputs(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-webacl-outputs-%d", time.Now().Unix()),
	})

	requiredOutputs := []string{
		"web_acl_id",
		"web_acl_arn",
		"web_acl_name",
		"web_acl_capacity",
	}

	outputs := terraform.OutputAll(t, ctx.Terraform)
	for _, outputName := range requiredOutputs {
		_, exists := outputs[outputName]
		assert.True(t, exists, "required output '%s' must be defined", outputName)
	}
}

// TestBasicWebACLIdempotency verifies that applying the same config twice produces no changes.
func TestBasicWebACLIdempotency(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-webacl-idempotency-%d", time.Now().Unix()),
	})

	assertions.AssertIdempotent(t, ctx)
}

// TestBasicWebACLTerraformValidate runs terraform validate on the basic example.
func TestBasicWebACLTerraformValidate(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-webacl-validate-%d", time.Now().Unix()),
	})

	validateOptions := &terraform.Options{
		TerraformDir: ctx.Terraform.TerraformDir,
	}
	terraform.Validate(t, validateOptions)
}

// TestBasicWebACLArnFormat verifies the Web ACL ARN matches the expected AWS WAFv2 format.
func TestBasicWebACLArnFormat(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-webacl-arn-format-%d", time.Now().Unix()),
	})

	helpers.AssertWebACLArnFormat(t, ctx.Terraform, "web_acl_arn")
}

// TestBasicWebACLNoAssociation verifies no resource association exists in the basic example.
func TestBasicWebACLNoAssociation(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-webacl-no-assoc-%d", time.Now().Unix()),
	})

	helpers.AssertResourceCountExact(t, ctx.Terraform, "aws_wafv2_web_acl_association", 0)
	helpers.AssertResourceCountExact(t, ctx.Terraform, "aws_wafv2_web_acl_logging_configuration", 0)
}

// TestBasicWebACLStateContainsWebACL verifies the module resource path in state.
func TestBasicWebACLStateContainsWebACL(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-webacl-state-%d", time.Now().Unix()),
	})

	helpers.AssertStateContains(t, ctx.Terraform, "module.waf_webacl.aws_wafv2_web_acl.this")
}
