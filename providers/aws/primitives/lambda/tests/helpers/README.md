# Test Helpers

This directory contains helper functions that can be used across all tests.

## Helper Functions

### `helpers.go`

This file contains all helper functions for tests:

#### ARN Validation

- **AssertValidLambdaARN**: Verifies that the given value is a syntactically valid Lambda function ARN

## Usage

To use these helpers in your tests:

```go
import (
    "testing"

    "github.com/caylent-solutions/terraform-modules/providers/aws/primitives/lambda/tests/helpers"
    "github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
)

func TestExample(t *testing.T) {
    // Run your test
    ctx := testctx.RunSingleExample(t, "../../examples", "example", testctx.TestConfig{
        Name: "example-test",
    })

    // Validate the Lambda function ARN
    functionArn := ctx.GetOutput(t, "function_arn")
    helpers.AssertValidLambdaARN(t, functionArn)
}
```
