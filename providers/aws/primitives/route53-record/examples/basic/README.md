# route53-record / basic example

Provisions a private hosted zone in a fresh test VPC and creates two records using the `route53-record` primitive: an A record (with two values) and a CNAME pointing at it.

## What it creates

- `aws_vpc.test` -- test VPC (10.99.0.0/16)
- `aws_route53_zone.test` -- private hosted zone associated to the test VPC
- `module.record_a` -- A record with two values (60s TTL)
- `module.record_cname` -- CNAME pointing at the A record (60s TTL)

## Apply

```bash
cd providers/aws/primitives/route53-record/examples/basic
terraform init
terraform apply -auto-approve
```
