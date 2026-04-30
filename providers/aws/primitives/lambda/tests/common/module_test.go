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
		t.Parallel()
		functionArn := ctx.GetOutput(t, "function_arn")
		assert.NotEmpty(t, functionArn, "function_arn output should not be empty")
		assert.Contains(t, functionArn, "arn:aws:lambda", "function_arn should be a valid Lambda ARN")

		invokeArn := ctx.GetOutput(t, "function_invoke_arn")
		assert.NotEmpty(t, invokeArn, "function_invoke_arn output should not be empty")
		assert.Contains(t, invokeArn, "apigateway", "function_invoke_arn should reference apigateway service")

		version := ctx.GetOutput(t, "function_version")
		assert.NotEmpty(t, version, "function_version output should not be empty")
	})

	t.Run("FunctionConfiguration", func(t *testing.T) {
		t.Parallel()
		functionName := ctx.GetOutput(t, "function_name")
		assert.NotEmpty(t, functionName, "function_name should not be empty")
		assert.Contains(t, functionName, "test-lambda", "function_name should match configured prefix")
	})

	t.Run("TracingConfiguration", func(t *testing.T) {
		t.Parallel()
		tracingMode := ctx.GetOutput(t, "tracing_mode")
		assert.NotEmpty(t, tracingMode, "tracing_mode should not be empty")
		assert.Equal(t, "Active", tracingMode, "tracing_mode should be Active as configured in the zip example")
	})

	t.Run("PublishBehavior", func(t *testing.T) {
		t.Parallel()
		version := ctx.GetOutput(t, "function_version")
		assert.NotEmpty(t, version, "function_version should not be empty")

		_, err := strconv.Atoi(strings.TrimSpace(version))
		assert.NoError(t, err, "version should be a numeric string when publish=true")
	})
}
