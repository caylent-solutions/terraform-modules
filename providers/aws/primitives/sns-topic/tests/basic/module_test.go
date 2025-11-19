package basic_test

import (
    "testing"
    "github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestBasicSNS(t *testing.T) {
    t.Parallel()

    ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
        Name: "sns-basic-test",
    })

    topicArn := terraform.Output(t, ctx.Terraform, "topic_arn")
    topicName := terraform.Output(t, ctx.Terraform, "topic_name")

    assert.NotEmpty(t, topicArn)
    assert.Contains(t, topicArn, "arn:aws:sns")
    assert.NotEmpty(t, topicName)
}