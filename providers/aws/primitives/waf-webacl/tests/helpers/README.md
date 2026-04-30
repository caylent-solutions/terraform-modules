# WAFv2 Web ACL Test Helpers

This directory contains helper functions for the `waf-webacl` module tests.

## Helper Functions

### `helpers.go`

WAFv2-specific assertion helpers:

- **AssertWebACLArnFormat**: Validates that a WAFv2 regional WebACL ARN matches the expected format (`arn:aws:wafv2:<region>:<account>:regional/webacl/<name>/<id>`)
- **AssertOutputNotEmpty**: Asserts that a named Terraform output is non-empty
- **AssertOutputEmpty**: Asserts that a named Terraform output is empty
- **AssertResourceCountExact**: Counts occurrences of a resource type in Terraform state and asserts an exact number
- **AssertStateContains**: Asserts that a specific resource path exists in Terraform state

## Usage

```go
import (
    "testing"

    "github.com/caylent-solutions/terraform-modules/providers/aws/primitives/waf-webacl/tests/helpers"
    "github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
)

func TestWebACL(t *testing.T) {
    ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
        Name: "test",
    })

    helpers.AssertWebACLArnFormat(t, ctx.Terraform, "web_acl_arn")
    helpers.AssertOutputNotEmpty(t, ctx.Terraform, "web_acl_id")
    helpers.AssertStateContains(t, ctx.Terraform, "module.waf_webacl.aws_wafv2_web_acl.this")
}
```
