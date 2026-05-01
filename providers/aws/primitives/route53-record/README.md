# route53-record

AWS Route53 record primitive Terraform module. Creates a single record in an existing hosted zone (the zone must be provisioned separately by the consumer).

Ships:

- `aws_route53_record` with full type support (A/AAAA/CNAME/CAA/MX/NAPTR/NS/PTR/SOA/SPF/SRV/TXT)
- TTL+records OR alias target (mutually exclusive; the module ignores ttl/records when alias is set)
- Optional health check id
- Optional routing policies: weighted, failover, geolocation, latency (mutually exclusive)
- Optional set_identifier for routing-policy records

## Usage

```hcl
module "api_a" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/route53-record?ref=providers/aws/primitives/route53-record/v0.1.0"

  zone_id = aws_route53_zone.telemetry.id
  name    = "api.telemetry.internal"
  type    = "A"
  ttl     = 60
  records = ["10.0.1.10", "10.0.1.11"]
}

module "api_alias" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/route53-record?ref=providers/aws/primitives/route53-record/v0.1.0"

  zone_id = aws_route53_zone.public.id
  name    = "api.example.com"
  type    = "A"

  alias = {
    name                   = aws_lb.api.dns_name
    zone_id                = aws_lb.api.zone_id
    evaluate_target_health = true
  }
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/primitives/route53-record
```
