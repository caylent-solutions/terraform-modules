# opensearch-domain / basic example

Provisions a single-node OpenSearch domain with encryption-at-rest (AWS-managed key), node-to-node encryption, HTTPS-only access, and an IAM access policy granting full access to the caller identity. Application logs publish to a per-domain CloudWatch Log Group.

## What it creates

- `module.domain` -- the `opensearch-domain` primitive on a `t3.small.search` data node
- `data.aws_iam_policy_document.domain_access` -- IAM policy granting `es:*` to the caller's ARN

## Apply

```bash
cd providers/aws/primitives/opensearch-domain/examples/basic
terraform init
terraform apply -auto-approve
```

Domain creation takes ~15-25 minutes.
