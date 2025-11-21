package crossaccount_test

import (
	"context"
	"encoding/json"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sns"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestCrossAccountSNS(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "cross-account", testctx.TestConfig{
		Name: "sns-cross-account-test",
	})

	topicArn := terraform.Output(t, ctx.Terraform, "topic_arn")
	topicName := terraform.Output(t, ctx.Terraform, "topic_name")

	// Basic output validation
	assert.NotEmpty(t, topicArn)
	assert.Contains(t, topicArn, "arn:aws:sns")
	assert.NotEmpty(t, topicName)

	// Initialize AWS SDK client
	awsCtx := context.Background()
	cfg, err := config.LoadDefaultConfig(awsCtx)
	require.NoError(t, err)
	snsClient := sns.NewFromConfig(cfg)

	// Verify topic exists and is accessible
	attrs, err := snsClient.GetTopicAttributes(awsCtx, &sns.GetTopicAttributesInput{
		TopicArn: aws.String(topicArn),
	})
	require.NoError(t, err)
	assert.NotNil(t, attrs)

	// Verify policy is set
	assert.Contains(t, attrs.Attributes, "Policy")
	policyStr := attrs.Attributes["Policy"]
	assert.NotEmpty(t, policyStr)

	// Parse and verify policy structure
	var policy map[string]interface{}
	err = json.Unmarshal([]byte(policyStr), &policy)
	require.NoError(t, err)

	// Verify policy has statements
	statements, ok := policy["Statement"].([]interface{})
	require.True(t, ok, "Policy should have Statement array")
	assert.GreaterOrEqual(t, len(statements), 2, "Policy should have at least 2 statements")

	// Verify service principal statement exists
	foundServicePrincipal := false
	for _, stmt := range statements {
		statement := stmt.(map[string]interface{})
		if sid, ok := statement["Sid"].(string); ok {
			if sid == "AllowS3ServicePublish" {
				foundServicePrincipal = true
				// Verify service principal
				principal := statement["Principal"].(map[string]interface{})
				assert.Contains(t, principal, "Service")
			}
		}
	}
	assert.True(t, foundServicePrincipal, "Policy should contain service principal statement")

	// Verify encryption is enabled
	assert.Contains(t, attrs.Attributes, "KmsMasterKeyId")
	assert.Equal(t, "alias/aws/sns", attrs.Attributes["KmsMasterKeyId"])

	// Verify tags applied correctly
	tags, err := snsClient.ListTagsForResource(awsCtx, &sns.ListTagsForResourceInput{
		ResourceArn: aws.String(topicArn),
	})
	require.NoError(t, err)
	assert.NotNil(t, tags.Tags)
	tagMap := make(map[string]string)
	for _, tag := range tags.Tags {
		tagMap[*tag.Key] = *tag.Value
	}
	assert.Equal(t, "dev", tagMap["Environment"])
	assert.Equal(t, "sns-cross-account-example", tagMap["Project"])

	// Verify can publish message (from current account)
	publishOutput, err := snsClient.Publish(awsCtx, &sns.PublishInput{
		TopicArn: aws.String(topicArn),
		Message:  aws.String("Test message from Terratest"),
	})
	require.NoError(t, err)
	assert.NotEmpty(t, publishOutput.MessageId)

	// Verify input name matches output
	varFilePath := ctx.Terraform.TerraformDir + "/terraform.tfvars"
	inputName := terraform.GetVariableAsStringFromVarFile(t, varFilePath, "name")
	assert.Equal(t, inputName, topicName)
}
