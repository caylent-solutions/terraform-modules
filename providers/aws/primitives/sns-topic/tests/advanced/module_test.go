package advanced_test

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sns"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestAdvancedSNS(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "advanced", testctx.TestConfig{
		Name: "sns-advanced-test",
	})

	topicArn := terraform.Output(t, ctx.Terraform, "topic_arn")
	topicName := terraform.Output(t, ctx.Terraform, "topic_name")

	// Basic output validation
	assert.NotEmpty(t, topicArn)
	assert.Contains(t, topicArn, "arn:aws:sns")
	assert.NotEmpty(t, topicName)
	assert.Contains(t, topicName, ".fifo")

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

	// Verify FIFO topic configuration
	assert.Equal(t, "true", attrs.Attributes["FifoTopic"])
	assert.Equal(t, "true", attrs.Attributes["ContentBasedDeduplication"])

	// Verify tracing configuration
	assert.Equal(t, "Active", attrs.Attributes["TracingConfig"])

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
	assert.Equal(t, "sns-advanced-example", tagMap["Project"])

	// Verify can publish message with MessageGroupId (required for FIFO)
	publishOutput, err := snsClient.Publish(awsCtx, &sns.PublishInput{
		TopicArn:       aws.String(topicArn),
		Message:        aws.String("Test message from Terratest"),
		MessageGroupId: aws.String("test-group"),
	})
	require.NoError(t, err)
	assert.NotEmpty(t, publishOutput.MessageId)

	// Verify input name matches output
	varFilePath := ctx.Terraform.TerraformDir + "/terraform.tfvars"
	inputName := terraform.GetVariableAsStringFromVarFile(t, varFilePath, "name")
	assert.Equal(t, inputName, topicName)
}
