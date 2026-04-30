package basic_test

import (
	"fmt"
	"regexp"
	"strings"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// TestBasicDynamoDBSuite runs a shared apply/destroy lifecycle across multiple assertions,
// reducing AWS provisioning overhead by sharing infrastructure across subtests.
func TestBasicDynamoDBSuite(t *testing.T) {
	t.Parallel()

	tableName := fmt.Sprintf("test-dynamodb-suite-%d", time.Now().Unix())

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-table-suite-test",
		ExtraVars: map[string]interface{}{
			"name":     tableName,
			"hash_key": "pk",
		},
	})

	t.Run("ARNFormat", func(t *testing.T) {
		assertions.AssertOutputMatches(t, ctx, "table_arn", `^arn:aws:dynamodb:[a-z0-9-]+:[0-9]{12}:table/[a-zA-Z0-9_.-]+$`)
	})

	t.Run("NameMatchesInput", func(t *testing.T) {
		outputName := terraform.Output(t, ctx.Terraform, "table_name")
		if outputName != tableName {
			t.Fatalf("expected table_name to be %q, got %q", tableName, outputName)
		}
	})

	t.Run("ARNContainsTableName", func(t *testing.T) {
		tableARN := terraform.Output(t, ctx.Terraform, "table_arn")
		matched, err := regexp.MatchString(fmt.Sprintf(`table/%s$`, regexp.QuoteMeta(tableName)), tableARN)
		if err != nil {
			t.Fatalf("regex error: %v", err)
		}
		if !matched {
			t.Fatalf("expected table_arn to contain table name %q, got %q", tableName, tableARN)
		}
	})

	t.Run("HashKeyMatchesInput", func(t *testing.T) {
		assertions.AssertOutputEquals(t, ctx, "table_hash_key", "pk")
	})

	t.Run("BillingModePAYPERREQUEST", func(t *testing.T) {
		assertions.AssertOutputEquals(t, ctx, "table_billing_mode", "PAY_PER_REQUEST")
	})

	t.Run("StreamARNEmptyWhenDisabled", func(t *testing.T) {
		assertions.AssertOutputEmpty(t, ctx, "table_stream_arn")
	})

	t.Run("ResourceCountIsOne", func(t *testing.T) {
		state := terraform.RunTerraformCommand(t, ctx.Terraform, "state", "list")
		tableCount := strings.Count(state, "aws_dynamodb_table.this")
		if tableCount != 1 {
			t.Fatalf("expected exactly 1 aws_dynamodb_table resource, found %d in state: %s", tableCount, state)
		}
	})

	t.Run("StateContainsModuleTable", func(t *testing.T) {
		state := terraform.RunTerraformCommand(t, ctx.Terraform, "state", "list")
		if !strings.Contains(state, "module.dynamodb_table.aws_dynamodb_table.this") {
			t.Fatalf("expected state to contain module.dynamodb_table.aws_dynamodb_table.this, got: %s", state)
		}
	})

	t.Run("RequiredOutputsNonEmpty", func(t *testing.T) {
		assertions.AssertOutputNotEmpty(t, ctx, "table_arn")
		assertions.AssertOutputNotEmpty(t, ctx, "table_id")
		assertions.AssertOutputNotEmpty(t, ctx, "table_name")
		assertions.AssertOutputNotEmpty(t, ctx, "table_hash_key")
		assertions.AssertOutputNotEmpty(t, ctx, "table_billing_mode")
	})
}

// TestBasicDynamoDBTerraformValidate runs 'terraform validate' on the basic example.
func TestBasicDynamoDBTerraformValidate(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-table-validate-test",
		ExtraVars: map[string]interface{}{
			"name": fmt.Sprintf("test-dynamodb-validate-%d", time.Now().Unix()),
		},
	})

	validateOptions := &terraform.Options{
		TerraformDir: ctx.Terraform.TerraformDir,
	}
	terraform.Validate(t, validateOptions)
}

// TestBasicDynamoDBIdempotency tests idempotency of the basic example.
func TestBasicDynamoDBIdempotency(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-table-idempotency-test",
		ExtraVars: map[string]interface{}{
			"name": fmt.Sprintf("test-dynamodb-idem-%d", time.Now().Unix()),
		},
	})

	assertions.AssertIdempotent(t, ctx)
}

// TestBasicDynamoDBTerraformFormat checks if the Terraform code is properly formatted.
func TestBasicDynamoDBTerraformFormat(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-table-format-test",
		ExtraVars: map[string]interface{}{
			"name": fmt.Sprintf("test-dynamodb-fmt-%d", time.Now().Unix()),
		},
	})

	output, err := terraform.RunTerraformCommandE(t, ctx.Terraform, "fmt", "-check", "-recursive")
	if err != nil {
		t.Fatalf("Terraform fmt failed: %v", err)
	}
	if output != "" {
		t.Fatalf("Terraform code is not properly formatted: %s", output)
	}
}
