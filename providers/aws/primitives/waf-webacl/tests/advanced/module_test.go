package advanced_test

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

// TestAdvancedWebACLCreation verifies the advanced Web ACL and IP set are created.
func TestAdvancedWebACLCreation(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "advanced", testctx.TestConfig{
		Name: fmt.Sprintf("advanced-webacl-creation-%d", time.Now().Unix()),
	})

	helpers.AssertWebACLArnFormat(t, ctx.Terraform, "web_acl_arn")
}

// TestAdvancedWebACLIPSetEnabled verifies the IP set is created when enable_ip_set_rule is true.
func TestAdvancedWebACLIPSetEnabled(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "advanced", testctx.TestConfig{
		Name: fmt.Sprintf("advanced-webacl-ipset-%d", time.Now().Unix()),
	})

	helpers.AssertOutputNotEmpty(t, ctx.Terraform, "ip_set_arn")
	helpers.AssertOutputNotEmpty(t, ctx.Terraform, "ip_set_id")

	ipSetArn := terraform.Output(t, ctx.Terraform, "ip_set_arn")
	assert.Regexp(t, `^arn:aws:wafv2:[a-z0-9-]+:[0-9]{12}:regional/ipset/`, ipSetArn,
		"ip_set_arn must match WAFv2 regional ipset ARN format")
}

// TestAdvancedWebACLResourceCount verifies both Web ACL and IP set are in state.
func TestAdvancedWebACLResourceCount(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "advanced", testctx.TestConfig{
		Name: fmt.Sprintf("advanced-webacl-resource-count-%d", time.Now().Unix()),
	})

	helpers.AssertResourceCountExact(t, ctx.Terraform, "module.waf_webacl.aws_wafv2_web_acl.this", 1)
	helpers.AssertStateContains(t, ctx.Terraform, "aws_wafv2_ip_set")
}

// TestAdvancedWebACLIdempotency verifies the advanced example is idempotent.
func TestAdvancedWebACLIdempotency(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "advanced", testctx.TestConfig{
		Name: fmt.Sprintf("advanced-webacl-idempotency-%d", time.Now().Unix()),
	})

	assertions.AssertIdempotent(t, ctx)
}
