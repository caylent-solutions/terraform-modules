package basic_test

import (
	"fmt"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-modules/providers/aws/primitives/route53-record/tests/helpers"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
)

// TestBasicRoute53RecordConfiguration tests that an A record is created successfully
func TestBasicRoute53RecordConfiguration(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-r53-config-%d", time.Now().Unix()),
	})

	helpers.AssertOutputNotEmpty(t, ctx.Terraform, "record_name")
	helpers.AssertOutputNotEmpty(t, ctx.Terraform, "record_fqdn")
	helpers.AssertOutputNotEmpty(t, ctx.Terraform, "record_type")
}

// TestBasicRoute53RecordFQDN tests that the FQDN output matches the expected pattern
func TestBasicRoute53RecordFQDN(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-r53-fqdn-%d", time.Now().Unix()),
	})

	helpers.AssertOutputMatchesRegex(t, ctx.Terraform, "record_fqdn", `^[a-z0-9.-]+$`)
}

// TestBasicRoute53RecordType tests that the record type is returned correctly
func TestBasicRoute53RecordType(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-r53-type-%d", time.Now().Unix()),
	})

	helpers.AssertOutputEquals(t, ctx.Terraform, "record_type", "A")
}

// TestBasicRoute53RecordResourceCounts verifies exactly one Route53 record is created
func TestBasicRoute53RecordResourceCounts(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-r53-counts-%d", time.Now().Unix()),
	})

	helpers.AssertResourceCountExact(t, ctx.Terraform, "aws_route53_record", 1)
}

// TestBasicRoute53RecordIdempotency verifies that applying the same config twice produces no changes
func TestBasicRoute53RecordIdempotency(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-r53-idem-%d", time.Now().Unix()),
	})

	assertions.AssertIdempotent(t, ctx)
}

// TestBasicRoute53RecordStateContains verifies the record resource appears in state
func TestBasicRoute53RecordStateContains(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-r53-state-%d", time.Now().Unix()),
	})

	helpers.AssertStateContains(t, ctx.Terraform, "module.route53_record.aws_route53_record.record")
}
