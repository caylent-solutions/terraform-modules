package basic_test

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestSecretsManagerSecretBasicFeatures(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	secretArn := terraform.Output(t, ctx.Terraform, "secret_arn")
	secretName := terraform.Output(t, ctx.Terraform, "secret_name")
	versionID := terraform.Output(t, ctx.Terraform, "secret_version_id")
	kmsArn := terraform.Output(t, ctx.Terraform, "kms_key_arn")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")
	sm := secretsmanager.NewFromConfig(cfg)

	t.Run("SecretExists", func(t *testing.T) {
		assert.NotEmpty(t, secretArn)
		assert.True(t, strings.Contains(secretArn, ":secretsmanager:"), "ARN should be a Secrets Manager ARN")
		assert.True(t, strings.HasPrefix(secretName, "test-sm-secret-"), "name should be prefixed by var.secret_name")
		assert.NotEmpty(t, versionID, "secret_version_id should be set when initial_secret_string is provided")
	})

	t.Run("DescribeSecretMatchesInputs", func(t *testing.T) {
		out, err := sm.DescribeSecret(t.Context(), &secretsmanager.DescribeSecretInput{
			SecretId: aws.String(secretArn),
		})
		require.NoError(t, err, "DescribeSecret")
		assert.Equal(t, kmsArn, aws.ToString(out.KmsKeyId), "KMS key id should match the test CMK ARN")
		assert.Equal(t, secretName, aws.ToString(out.Name), "name should match")
	})

	t.Run("InitialSecretValueRetrievable", func(t *testing.T) {
		out, err := sm.GetSecretValue(t.Context(), &secretsmanager.GetSecretValueInput{
			SecretId: aws.String(secretArn),
		})
		require.NoError(t, err, "GetSecretValue")
		require.NotEmpty(t, aws.ToString(out.SecretString))

		var payload map[string]string
		require.NoError(t, json.Unmarshal([]byte(aws.ToString(out.SecretString)), &payload), "secret value should be valid JSON")
		assert.Equal(t, "admin", payload["username"], "JSON username should be admin")
		assert.True(t, strings.HasPrefix(payload["password"], "p@ssw0rd-"), "JSON password should start with p@ssw0rd-")
	})
}
