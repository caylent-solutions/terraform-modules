# route53-record Terraform Module

This module creates an AWS Route53 DNS record (A, CNAME, ALIAS, or any supported type) in an existing hosted zone.

## Description

The `route53-record` primitive manages a single `aws_route53_record` resource. It supports:

- Standard records (A, AAAA, CNAME, MX, TXT, etc.) with TTL and record values
- Alias records pointing to AWS resources (ELB, CloudFront, S3, etc.)
- Routing policies: weighted, failover, geolocation, latency, multivalue answer
- Health check association
- Overwrite protection

The hosted zone must be created separately (for example via the `aws_route53_zone` resource in the consuming Terragrunt module).

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.12.1
- [Go](https://golang.org/doc/install) >= 1.24
- An existing Route53 hosted zone

## Usage

### A Record Example

```hcl
module "route53_record" {
  source  = "git::ssh://git@github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/route53-record?ref=providers/aws/primitives/route53-record/v0.1.0"

  zone_id = "Z1234567890ABC"
  name    = "api.example.com"
  type    = "A"
  ttl     = 300
  records = ["1.2.3.4"]
}
```

### ALIAS Record Example

```hcl
module "route53_record" {
  source  = "git::ssh://git@github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/route53-record?ref=providers/aws/primitives/route53-record/v0.1.0"

  zone_id = "Z1234567890ABC"
  name    = "app.example.com"
  type    = "A"

  alias = {
    name                   = "my-load-balancer.us-east-1.elb.amazonaws.com"
    zone_id                = "Z35SXDOTRQ7X7K"
    evaluate_target_health = true
  }
}
```

## Getting Started

```bash
make cpm-configure
make install
make test
```

## Module Structure

```
route53-record/
├── examples/
│   └── basic/          # Minimal A record example
├── tests/
│   ├── basic/          # Terratest for basic example
│   └── helpers/        # Shared test helpers
├── main.tf             # aws_route53_record resource
├── variables.tf        # Input variables
├── outputs.tf          # Output values
├── versions.tf         # required_version + required_providers
├── locals.tf           # Local values
└── TERRAFORM-DOCS.md   # Auto-generated documentation
```

## Inputs

See `variables.tf` and `TERRAFORM-DOCS.md` for full input documentation.

## Outputs

| Name | Description |
|------|-------------|
| `record_name` | The name of the Route53 record |
| `record_fqdn` | The fully qualified domain name of the record |
| `record_type` | The record type |
| `record_zone_id` | The zone ID of the hosted zone containing the record |
| `record_ttl` | The TTL of the record |

## Examples

See `examples/basic/` for a complete working example.

## Testing

```bash
make test
make go-lint
make go-format
```

## References

- [AWS Route53 Record Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)
- [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework)
