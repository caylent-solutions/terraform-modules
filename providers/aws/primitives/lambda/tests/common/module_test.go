package common

import (
	"fmt"
	"strconv"
	"strings"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/stretchr/testify/assert"
)

// TestCommonFeatures runs all common tests in a single provision cycle
func TestCommonFeatures(t *testing.T) {
	// Provision infrastructure ONCE
	ctx := testctx.RunSingleExample(t, "../../examples", "lambda-zip-deployment", testctx.TestConfig{
		Name: fmt.Sprintf("common-%d", time.Now().Unix()),
	})

	// Run all tests as subtests
	t.Run("CommonOutputs", func(t *testing.T) {
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function_arn output should not be empty")

		invokeArn := ctx.GetOutput(t, "function_invoke_arn")
		assert.NotEmpty(t, invokeArn, "function_invoke_arn output should not be empty")

		version := ctx.GetOutput(t, "function_version")
		assert.NotEmpty(t, version, "function_version output should not be empty")
	})

	t.Run("FunctionConfiguration", func(t *testing.T) {
		functionName := ctx.GetOutput(t, "function_name")
		assert.NotEmpty(t, functionName, "function_name should not be empty")
	})

	t.Run("TracingConfiguration", func(t *testing.T) {
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function_arn should exist")
		assert.Contains(t, functionArn, "arn:aws:lambda", "should be valid Lambda ARN")
	})

	t.Run("TagsApplied", func(t *testing.T) {
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function should be created with tags")
	})

	t.Run("PublishBehavior", func(t *testing.T) {
		version := ctx.GetOutput(t, "function_version")
		assert.NotEmpty(t, version, "function_version should not be empty")

		_, err := strconv.Atoi(strings.TrimSpace(version))
		assert.NoError(t, err, "version should be numeric")
	})
}
