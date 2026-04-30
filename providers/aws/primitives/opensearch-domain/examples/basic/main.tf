resource "random_id" "suffix" {
  byte_length = 4
}

data "aws_caller_identity" "current" {}

# Open access policy for the basic test (the domain is public-mode and
# uses fine-grained access control via the master IAM principal). Real
# deployments should constrain this to specific principals + actions.
data "aws_iam_policy_document" "domain_access" {
  statement {
    effect    = "Allow"
    actions   = ["es:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.arn]
    }
  }
}

module "domain" {
  source = "../../"

  domain_name    = "${var.domain_name_prefix}-${random_id.suffix.hex}"
  engine_version = var.engine_version

  instance_type  = var.instance_type
  instance_count = var.instance_count

  ebs_volume_type = "gp3"
  ebs_volume_size = 10

  access_policies_json = data.aws_iam_policy_document.domain_access.json

  log_retention_in_days = var.log_retention_in_days

  tags = var.tags
}

output "domain_arn" {
  description = "ARN of the OpenSearch domain."
  value       = module.domain.domain_arn
}

output "domain_name" {
  description = "Name of the OpenSearch domain."
  value       = module.domain.domain_name
}

output "endpoint" {
  description = "Domain endpoint."
  value       = module.domain.endpoint
}

output "log_group_arn" {
  description = "Application log group ARN."
  value       = module.domain.log_group_arn
}
