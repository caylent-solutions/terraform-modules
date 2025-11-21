package common_test

import (
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestCommonOutputs(t *testing.T) {
	t.Parallel()

	examples := []string{"basic", "complete", "fifo", "cross-account"}

	for _, example := range examples {
		example := example
		t.Run(example, func(t *testing.T) {
			t.Parallel()

			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "sns-common-" + example,
			})

			// Verify required outputs exist
			topicArn := terraform.Output(t, ctx.Terraform, "topic_arn")
			topicName := terraform.Output(t, ctx.Terraform, "topic_name")

			assert.NotEmpty(t, topicArn)
			assert.Contains(t, topicArn, "arn:aws:sns")
			assert.NotEmpty(t, topicName)
		})
	}
}
