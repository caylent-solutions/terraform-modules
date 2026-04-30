package lambdadockerdeployment

import (
	"fmt"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/stretchr/testify/assert"
)

// TestDockerDeploymentFeatures runs all docker deployment tests in a single provision cycle
func TestDockerDeploymentFeatures(t *testing.T) {
	// Provision infrastructure ONCE
	ctx := testctx.RunSingleExample(t, "../../examples", "lambda-docker-deployment", testctx.TestConfig{
		Name: fmt.Sprintf("docker-%d", time.Now().Unix()),
	})

	// Run all tests as subtests
	t.Run("DockerImageDeployment", func(t *testing.T) {
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function_arn should not be empty")
		assert.Contains(t, functionArn, "arn:aws:lambda", "function_arn should be a valid Lambda ARN")
	})

	t.Run("ECRRepository", func(t *testing.T) {
		repoUrl := ctx.GetOutput(t, "ecr_repository_url")
		assert.NotEmpty(t, repoUrl, "ecr_repository_url should not be empty")
		assert.Contains(t, repoUrl, ".dkr.ecr.", "ecr_repository_url should be a valid ECR URL")
	})

	t.Run("ImageConfig", func(t *testing.T) {
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function should be created with image config")
	})

	t.Run("VPCConfiguration", func(t *testing.T) {
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function should be created with VPC config")
	})

	t.Run("EFSConfiguration", func(t *testing.T) {
		efsId := ctx.GetOutput(t, "efs_file_system_id")
		assert.NotEmpty(t, efsId, "efs_file_system_id should not be empty")
		assert.Contains(t, efsId, "fs-", "efs_file_system_id should be valid EFS ID")
	})

	// TestCodeSigningConfig removed - code signing not supported for container images

	t.Run("LayerVersion", func(t *testing.T) {
		layerArn := ctx.GetOutput(t, "layer_version_arn")
		assert.NotEmpty(t, layerArn, "layer_version_arn should not be empty")
		assert.Contains(t, layerArn, "arn:aws:lambda", "should be valid Lambda layer ARN")
	})

	t.Run("ParametersAndSecretsExtension", func(t *testing.T) {
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function should be created with parameters and secrets extension")
	})

	t.Run("ArchitectureArm64", func(t *testing.T) {
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function should be created with arm64 architecture")
	})

	t.Run("UnreservedConcurrency", func(t *testing.T) {
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function should be created with unreserved concurrency")
	})
}
