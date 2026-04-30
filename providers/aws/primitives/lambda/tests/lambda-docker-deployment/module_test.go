package lambdadockerdeployment

import (
	"fmt"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-modules/providers/aws/primitives/lambda/tests/helpers"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/stretchr/testify/assert"
)

// TestDockerDeploymentFeatures runs all docker deployment tests in a single provision cycle
func TestDockerDeploymentFeatures(t *testing.T) {
	t.Setenv("TERRATEST_IDEMPOTENCY", "false")

	// Provision infrastructure ONCE
	ctx := testctx.RunSingleExample(t, "../../examples", "lambda-docker-deployment", testctx.TestConfig{
		Name: fmt.Sprintf("docker-%d", time.Now().Unix()),
	})

	// Run all tests as subtests
	t.Run("DockerImageDeployment", func(t *testing.T) {
		t.Parallel()
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function_arn should not be empty")
		helpers.AssertValidLambdaARN(t, functionArn)
	})

	t.Run("ECRRepository", func(t *testing.T) {
		t.Parallel()
		repoUrl := ctx.GetOutput(t, "ecr_repository_url")
		assert.NotEmpty(t, repoUrl, "ecr_repository_url should not be empty")
		assert.Contains(t, repoUrl, ".dkr.ecr.", "ecr_repository_url should be a valid ECR URL")
		assert.Contains(t, repoUrl, ".amazonaws.com", "ecr_repository_url should be an AWS domain")
	})

	t.Run("EFSConfiguration", func(t *testing.T) {
		t.Parallel()
		efsId := ctx.GetOutput(t, "efs_file_system_id")
		assert.NotEmpty(t, efsId, "efs_file_system_id should not be empty")
		assert.Contains(t, efsId, "fs-", "efs_file_system_id should be valid EFS ID")
	})

	t.Run("LayerVersion", func(t *testing.T) {
		t.Parallel()
		layerArn := ctx.GetOutput(t, "layer_version_arn")
		assert.NotEmpty(t, layerArn, "layer_version_arn should not be empty")
		assert.Contains(t, layerArn, "arn:aws:lambda", "layer_version_arn should be a valid Lambda layer ARN")
		assert.Contains(t, layerArn, ":layer:", "layer_version_arn should contain :layer: segment")
	})

	t.Run("FunctionArm64Architecture", func(t *testing.T) {
		t.Parallel()
		architecture := ctx.GetOutput(t, "function_architecture")
		assert.NotEmpty(t, architecture, "function_architecture should not be empty")
		assert.Equal(t, "arm64", architecture, "function_architecture should be arm64 as configured in the example")
	})
}
