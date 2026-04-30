# Basic Route53 Record Example

This example demonstrates creating a simple A record in a Route53 hosted zone.

## Resources Created

- An AWS Route53 hosted zone (for testing purposes)
- An A record pointing to a static IP address

## Usage

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

## Inputs

| Name | Description | Default |
|------|-------------|---------|
| `zone_name` | The DNS name of the hosted zone | `caylent-terratest-r53-record.net` |
| `record_name` | The name of the DNS record | `api.caylent-terratest-r53-record.net` |
| `record_type` | The record type | `A` |
| `ttl` | TTL in seconds | `300` |
| `records` | List of record values | `["1.2.3.4"]` |

## Outputs

| Name | Description |
|------|-------------|
| `record_name` | The name of the Route53 record |
| `record_fqdn` | The fully qualified domain name |
| `record_type` | The record type |
| `record_zone_id` | The hosted zone ID |
| `record_ttl` | The record TTL |
| `zone_id` | The test hosted zone ID |
