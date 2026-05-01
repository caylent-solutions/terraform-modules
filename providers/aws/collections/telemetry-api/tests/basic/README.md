# Basic Example Tests

Terratest fixtures for `examples/basic/`. Asserted behavior:

- `OutputsPopulated` -- api_invoke_url, authorizer arn/name, rest_api_id,
  stage_name, web_acl_arn populated; custom_domain_name empty
- `RestAPIExists` -- `GetRestApi` returns id/name for the deployed API
- `StageExists` -- `GetStage` returns the configured stage name with
  X-Ray tracing enabled (the collection's default)
- `AuthorizerLambdaExists` -- `GetFunction` returns the authorizer
  Lambda's name/arn
- `WebACLExists` -- `GetWebACL` returns a WAF v2 Web ACL with
  `DefaultAction.Allow` populated

## Running

```bash
make tf-test MODULE_PATH=providers/aws/collections/telemetry-api
```
