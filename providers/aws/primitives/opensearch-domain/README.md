# opensearch-domain

AWS OpenSearch domain primitive Terraform module.

Ships:

- `aws_opensearch_domain` with always-on encryption-at-rest (customer-managed KMS supported), always-on node-to-node encryption, and always-on HTTPS enforcement (TLS 1.2 + PFS by default per `spec/security.md`)
- Configurable cluster topology: data nodes, dedicated master nodes, multi-AZ zone awareness
- Configurable EBS storage (gp3 / gp2 / io1) with optional IOPS and throughput overrides
- Optional VPC mode (`vpc_subnet_ids` + `vpc_security_group_ids`)
- Optional fine-grained access control via `advanced_security_master_user_arn`
- Optional custom (vanity) endpoint with ACM cert
- Always-on application log publishing to a per-module CloudWatch Log Group with a resource policy granting `es.amazonaws.com` write access
- IAM-based domain access policy (`access_policies_json`)

## Usage

```hcl
module "domain" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/opensearch-domain?ref=providers/aws/primitives/opensearch-domain/v0.1.0"

  domain_name    = "telemetry-search"
  engine_version = "OpenSearch_2.13"

  instance_type  = "r6g.large.search"
  instance_count = 3

  zone_awareness_enabled  = true
  availability_zone_count = 3

  ebs_volume_type = "gp3"
  ebs_volume_size = 100

  kms_key_id = aws_kms_key.search.arn

  access_policies_json = data.aws_iam_policy_document.search_access.json

  tags = { Application = "telemetry" }
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/primitives/opensearch-domain
```

OpenSearch domains take 15-25 minutes to create and a similar amount to destroy; expect Terratest to run for ~30+ minutes per fixture.
