# Module Tests

Terratest fixtures for the `api-gateway-rest-api` primitive module,
using the
[Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

- **basic/** -- Terratest for the `examples/basic/` example, asserting
  REST API + stage shape, method settings, access log wiring, usage
  plan, and that `GET /` returns HTTP 200 from the MOCK integration.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/api-gateway-rest-api
```
