package basic_test

import (
	"fmt"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestBasicSecretCreation verifies that a Secrets Manager secret is created with the expected properties.
func TestBasicSecretCreation(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-secret-create-%d", time.Now().Unix()),
	})

	// Verify secret ARN is not empty and matches expected format
	secretArn := terraform.Output(t, ctx.Terraform, "secret_arn")
	assert.NotEmpty(t, secretArn, "secret_arn output must not be empty")
	assert.Regexp(t, `^arn:aws:secretsmanager:[a-z0-9-]+:[0-9]{12}:secret:.+`, secretArn,
		"secret_arn must match AWS Secrets Manager ARN format")

	// Verify secret ID is not empty
	secretId := terraform.Output(t, ctx.Terraform, "secret_id")
	assert.NotEmpty(t, secretId, "secret_id output must not be empty")

	// Verify secret name is not empty
	secretName := terraform.Output(t, ctx.Terraform, "secret_name")
	assert.NotEmpty(t, secretName, "secret_name output must not be empty")
}

// TestBasicSecretKMSEncryption verifies that the secret is encrypted with a KMS key.
func TestBasicSecretKMSEncryption(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-secret-kms-%d", time.Now().Unix()),
	})

	// Verify KMS key ARN is present in outputs -- encryption is required
	kmsKeyId := terraform.Output(t, ctx.Terraform, "kms_key_id")
	assert.NotEmpty(t, kmsKeyId, "kms_key_id output must not be empty -- KMS encryption is required")
}

// TestBasicRequiredOutputs verifies that all required outputs are defined.
func TestBasicRequiredOutputs(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-secret-outputs-%d", time.Now().Unix()),
	})

	requiredOutputs := []string{
		"secret_arn",
		"secret_id",
		"secret_name",
		"kms_key_id",
	}

	outputs := terraform.OutputAll(t, ctx.Terraform)
	for _, outputName := range requiredOutputs {
		_, exists := outputs[outputName]
		assert.True(t, exists, "Required output %q must be defined", outputName)
	}
}

// TestBasicSecretResourceExists verifies that the aws_secretsmanager_secret resource exists in state.
func TestBasicSecretResourceExists(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-secret-resource-%d", time.Now().Unix()),
	})

	assertions.AssertResourceExists(t, ctx, "aws_secretsmanager_secret", "this")
}

// TestBasicIdempotency verifies that re-applying the basic example produces no changes.
func TestBasicIdempotency(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-secret-idempotency-%d", time.Now().Unix()),
	})

	assertions.AssertIdempotent(t, ctx)
}

// TestBasicTerraformVersion verifies that the Terraform version meets the minimum requirement.
func TestBasicTerraformVersion(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("basic-secret-tf-version-%d", time.Now().Unix()),
	})

	assertions.AssertTerraformVersion(t, ctx, "1.12.1")
}
