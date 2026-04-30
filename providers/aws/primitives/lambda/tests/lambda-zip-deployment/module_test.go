package lambdazipdeployment

import (
	"fmt"
	"strconv"
	"strings"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-modules/providers/aws/primitives/lambda/tests/helpers"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/stretchr/testify/assert"
)

// TestZipDeploymentFeatures runs all zip deployment tests in a single provision cycle
func TestZipDeploymentFeatures(t *testing.T) {
	t.Parallel()

	// Provision infrastructure ONCE
	ctx := testctx.RunSingleExample(t, "../../examples", "lambda-zip-deployment", testctx.TestConfig{
		Name: fmt.Sprintf("zip-%d", time.Now().Unix()),
	})

	// Run all tests as subtests
	t.Run("ZipPackageDeployment", func(t *testing.T) {
		t.Parallel()
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function_arn should not be empty")
		helpers.AssertValidLambdaARN(t, functionArn)
	})

	t.Run("EventSourceMapping", func(t *testing.T) {
		t.Parallel()
		uuid := ctx.GetOutput(t, "event_source_mapping_uuid")
		assert.NotEmpty(t, uuid, "event_source_mapping_uuid should not be empty")
		assert.Regexp(t, `^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$`, uuid,
			"event_source_mapping_uuid should be a valid UUID")

		state := ctx.GetOutput(t, "event_source_mapping_state")
		assert.Contains(t, []string{"Enabled", "Enabling", "Creating"}, state,
			"event_source_mapping_state should be valid")
	})

	t.Run("S3DeploymentMethod", func(t *testing.T) {
		t.Parallel()
		s3Bucket := ctx.GetOutput(t, "s3_bucket")
		assert.NotEmpty(t, s3Bucket, "s3_bucket should not be empty")

		s3Key := ctx.GetOutput(t, "s3_key")
		assert.NotEmpty(t, s3Key, "s3_key should not be empty")
		assert.Contains(t, s3Key, "function-", "s3_key should contain function prefix")
	})

	t.Run("FunctionUrl", func(t *testing.T) {
		t.Parallel()
		functionUrl := ctx.GetOutput(t, "function_url")
		assert.NotEmpty(t, functionUrl, "function_url should not be empty")
		assert.Contains(t, functionUrl, "https://", "function_url should be HTTPS")
		assert.Contains(t, functionUrl, ".lambda-url.", "function_url should be Lambda URL")
	})

	t.Run("Alias", func(t *testing.T) {
		t.Parallel()
		aliasArn := ctx.GetOutput(t, "alias_arn")
		assert.NotEmpty(t, aliasArn, "alias_arn should not be empty")
		assert.Contains(t, aliasArn, "arn:aws:lambda", "alias_arn should be a valid Lambda ARN")
		assert.Contains(t, aliasArn, ":prod", "alias_arn should contain prod alias name")
	})

	t.Run("ProvisionedConcurrency", func(t *testing.T) {
		t.Parallel()
		provisionedId := ctx.GetOutput(t, "provisioned_concurrency_id")
		assert.NotEmpty(t, provisionedId, "provisioned_concurrency_id should not be empty")
	})

	t.Run("PublishedVersion", func(t *testing.T) {
		t.Parallel()
		version := ctx.GetOutput(t, "function_version")
		assert.NotEmpty(t, version, "function_version should not be empty")
		_, err := strconv.Atoi(strings.TrimSpace(version))
		assert.NoError(t, err, "published version should be a numeric string")
	})
}
