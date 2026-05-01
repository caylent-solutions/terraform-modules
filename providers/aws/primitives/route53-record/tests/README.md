# Module Tests

Terratest fixtures for the `route53-record` primitive.

## Test Structure

- **basic/** -- Asserts the A and CNAME records in the test private hosted zone match their configured TTL and values.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/route53-record
```
