# aws-nuke configuration

Daily cleanup of the **sandbox** and **QA** AWS accounts via
[`ekristen/aws-nuke`](https://github.com/ekristen/aws-nuke). The pinned
binary version lives in the repo-root `.tool-versions`; install it
locally with `asdf install aws-nuke`.

| Account | Account ID | Role | Nuked? |
|---|---|---|---|
| `caylent-solutions-platform-sandbox` | `166185344421` | `default` SSO profile | yes (nightly) |
| `caylent-solutions-platform-qa` | `179743357982` | `platform-qa-admin` SSO profile | yes (nightly) |
| `caylent-solutions-platform-prod` | `136685436188` | `platform-prod-admin` SSO profile | **never** |
| `caylent-solutions-platform-root` | `468627576856` | `platform-root-admin` SSO profile | **never** |

The two prod-bucket accounts are **not** present in the workflow's
account matrix and are not referenced by any `vars.PLATFORM_*_AWS_ACCOUNT_NUMBER`
variable used by this workflow. They cannot be nuked accidentally
short of editing the workflow itself (which fails CI without a
human-reviewed PR).

## Files

- `aws-nuke-config.yaml` -- canonical multi-region config (17 enabled
  AWS regions; opt-in regions are deliberately excluded so calls to
  unreachable endpoints never burn the 90-min job timeout).
- `aws-nuke-config-us-east-2.yaml` -- single-region variant for
  ad-hoc per-region targeting. Filter list is identical to the
  canonical file by construction; if you change one, mirror the
  same edit into the other.

## What is protected

Both configs ship with the `complete-destruction` preset. That preset
adds explicit filters for:

**Bootstrap / control-plane state** (deleting any of these requires
hours of manual recovery before the platform can be re-applied):

- `IAMRole` -- `OrganizationAccountAccessRole`,
  `gh-actions-terraform-modules-pr-main-validation`,
  `TerragruntDeployRole`, every `gh-actions-*`,
  `AWSServiceRoleForAmazonGrafana`, every `AWSServiceRole*` SLR,
  every IAM role tagged `Service=caylent-telemetry`.
- `IAMPolicy` -- every AWS-managed policy
  (`arn:aws:iam::aws:policy/*`).
- `IAMRolePolicyAttachment` -- attachments of the above protected
  roles.
- `IAMOpenIDConnectProvider` -- the GitHub Actions OIDC provider
  (`token.actions.githubusercontent.com`).
- `CloudTrailTrail` -- `aws-controltower-BaselineCloudTrail` and
  every `aws-controltower-*` trail.
- `GuardDutyDetector` -- every detector (Control Tower / Security
  Hub managed baseline).
- `CloudFormationStack` -- the `trek10-iam-roles` MSP-team baseline
  (SEC-471), every `aws-controltower-*` and `AWSControlTower*`
  stack, and any stack tagged `team=msp`.

**Bootstrap state that the Terragrunt remote-state module relies on**:

- `S3Bucket` -- every `caylent-tfstate-*` bucket.
- `DynamoDBTable` -- the `caylent-tfstate-lock` table.
- `KMSKey` -- every key tagged `Service=caylent-telemetry` or named
  `caylent-tfstate-*`.
- `KMSAlias` -- every `alias/caylent-tfstate-*`,
  `alias/caylent-telemetry-*`, and `alias/aws/*` AWS-managed alias.

**caylent-telemetry-spec resources** (the platform spec at
`/workspaces/rpm-migration/caylent-telemetry-spec/`) -- API Gateway,
WAFv2, Lambdas, SQS, DynamoDB, EventBridge, OpenSearch, S3 snapshots
buckets, Route53 hosted zones + record sets under
`*.telemetry.solutions.caylent.com`, ACM certs for the same domain,
Secrets Manager `caylent/telemetry/*`, AppConfig `caylent-telemetry`
application + environments, Grafana workspaces, CloudWatch logs /
alarms / dashboards matching `caylent-telemetry-*`, SNS topics
matching `caylent-telemetry-alerts-*`, X-Ray groups + sampling
rules, and every VPC / subnet / route table / IGW / NAT / security
group / VPC endpoint tagged `Service=caylent-telemetry`.

## What is NOT protected

Anything else in the sandbox or QA account, including ad-hoc scratch
resources operators may have spun up outside the canonical naming
conventions. The contract is:

- If you want a resource preserved across nightly nukes: tag it
  `Service=caylent-telemetry` (declarative, recommended) OR name it
  with the `caylent-telemetry-*` / `telemetry-events-*` /
  `caylent-tfstate-*` prefix that the existing filters match.
- Otherwise: assume it gets wiped.

The dry-run preview surfaces every resource that would be deleted
before any deletion runs, so you can amend the protect list before
real-run if a previously-untracked resource needs to survive.

## Operator workflows

### Nightly automated cleanup

The `.github/workflows/nightly-aws-cleanup.yml` workflow runs at
06:00 UTC daily and nukes both sandbox and QA in parallel via a
matrix strategy. Each matrix arm reads the account number from the
GitHub variable named in the matrix entry
(`PLATFORM_SANDBOX_AWS_ACCOUNT_NUMBER` /
`PLATFORM_QA_AWS_ACCOUNT_NUMBER`). The workflow's blocklist is fed
from `vars.AWS_NUKE_BLOCKLIST`.

### Manual dry-run / real-run via workflow dispatch

From the Actions tab, dispatch `AWS Resource Cleanup`:

- `dry_run = true` (default) -- previews what would be deleted on
  both accounts; no deletions occur.
- `dry_run = false` -- real-run; resources are actually deleted.
  Restricted to GitHub admins via the `security-check` job.

### Local dry-run

```bash
aws sso login --profile default              # sandbox
# or: aws sso login --profile platform-qa-admin

# Inject the target account into a temp config:
yq eval '.blocklist = ["999999999999"]
        | .accounts["166185344421"] = {"presets":["complete-destruction"]}' \
    aws-nuke-config/aws-nuke-config.yaml > /tmp/nuke-sandbox-dry.yaml

# Optionally narrow regions to those enabled on the account:
ENABLED='["us-east-1","us-east-2","us-west-1","us-west-2","ca-central-1","sa-east-1","eu-west-1","eu-west-2","eu-west-3","eu-central-1","eu-north-1","ap-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-southeast-1","ap-southeast-2"]'
yq eval ".regions = $ENABLED" -i /tmp/nuke-sandbox-dry.yaml

AWS_PROFILE=default aws-nuke run \
  --config /tmp/nuke-sandbox-dry.yaml \
  --force --no-prompt --no-alias-check
```

Add `--no-dry-run` to actually delete (after reviewing the
preview).

## Adding a new resource type to the protect list

1. Reproduce the issue: run a dry-run and confirm the resource
   appears in the `would remove` list.
2. Identify the aws-nuke resource-type name (e.g. `LambdaFunction`,
   `OpenSearchDomain`). The dry-run output prints it.
3. Edit `aws-nuke-config.yaml`'s `presets.complete-destruction.filters`
   block and add a rule. Prefer `tag:Service: caylent-telemetry`
   over name globs when the resource type supports tag-based
   filtering -- it is more maintainable.
4. Mirror the same edit into `aws-nuke-config-us-east-2.yaml`.
5. Re-run the dry-run; confirm the previously-flagged resource now
   appears in the `filtered` count.
6. Open a PR with the diff. The PR-validation workflow lints the
   YAML.

## Known issues

- aws-nuke 3.56.x silently dropped a number of global-scope resource
  cleanups (Route53, IAM, CloudFront). Upgrading to 3.64.2 (this
  branch) fixes the affected paths. Local testing confirmed the
  upgrade matches the spec's expectations.
- aws-nuke retries opt-in regions (e.g. `me-south-1`,
  `ap-east-1`) for ~5 min each before failing; the canonical config
  excludes opt-in regions from the default `regions:` list to avoid
  burning the workflow's job timeout. If your account has those
  regions enabled, add them to the `regions_override` workflow
  input or to the canonical config.
