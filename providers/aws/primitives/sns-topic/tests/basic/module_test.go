package basic_test

import (
    "testing"

    "github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

// TestBasicSNS verifies that the SNS topic example deploys successfully
// and returns valid outputs (topic ARN and name)
func TestBasicSNS(t *testing.T) {
    t.Parallel()

    // Run the example "basic" under the sns-topic module
    ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
        Name: "sns-basic-test",
    })

    // Retrieve outputs
    topicArn := terraform.Output(t, ctx.Terraform, "topic_arn")
    topicName := terraform.Output(t, ctx.Terraform, "topic_name")

    // Assertions
    assert.NotEmpty(t, topicArn, "SNS Topic ARN should not be empty")
    assert.Contains(t, topicArn, "arn:aws:sns", "SNS Topic ARN should contain 'arn:aws:sns'")
    assert.NotEmpty(t, topicName, "SNS Topic name should not be empty")
}