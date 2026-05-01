resource "aws_opensearch_domain" "this" {
  domain_name    = var.domain_name
  engine_version = var.engine_version

  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type    = var.dedicated_master_enabled ? var.dedicated_master_type : null
    dedicated_master_count   = var.dedicated_master_enabled ? var.dedicated_master_count : null
    zone_awareness_enabled   = var.zone_awareness_enabled

    dynamic "zone_awareness_config" {
      for_each = var.zone_awareness_enabled ? [local.always_enabled] : []
      content {
        availability_zone_count = var.availability_zone_count
      }
    }
  }

  ebs_options {
    ebs_enabled = local.always_enabled
    volume_type = var.ebs_volume_type
    volume_size = var.ebs_volume_size
    iops        = var.ebs_iops
    throughput  = var.ebs_throughput
  }

  encrypt_at_rest {
    enabled    = local.always_enabled
    kms_key_id = var.kms_key_id
  }

  node_to_node_encryption {
    enabled = local.always_enabled
  }

  domain_endpoint_options {
    enforce_https                   = local.always_enabled
    tls_security_policy             = var.tls_security_policy
    custom_endpoint_enabled         = var.custom_endpoint_enabled
    custom_endpoint                 = var.custom_endpoint_enabled ? var.custom_endpoint : null
    custom_endpoint_certificate_arn = var.custom_endpoint_enabled ? var.custom_endpoint_certificate_arn : null
  }

  dynamic "vpc_options" {
    for_each = var.vpc_subnet_ids == null ? [] : [local.always_enabled]
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = var.vpc_security_group_ids
    }
  }

  dynamic "advanced_security_options" {
    for_each = var.advanced_security_master_user_arn == null ? [] : [local.always_enabled]
    content {
      enabled                        = local.always_enabled
      internal_user_database_enabled = local.always_disabled

      master_user_options {
        master_user_arn = var.advanced_security_master_user_arn
      }
    }
  }

  log_publishing_options {
    enabled                  = local.always_enabled
    log_type                 = local.log_type_application
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.application.arn
  }

  access_policies = var.access_policies_json

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "application" {
  name              = "${local.log_group_prefix}${var.domain_name}/application"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.log_kms_key_arn

  tags = var.tags
}

resource "aws_cloudwatch_log_resource_policy" "application" {
  policy_name     = "${var.domain_name}${local.log_resource_policy_name_suffix}"
  policy_document = data.aws_iam_policy_document.application_log.json
}

data "aws_iam_policy_document" "application_log" {
  statement {
    effect = local.effect_allow

    principals {
      type        = local.principal_type_service
      identifiers = [local.principal_es]
    }

    actions = [
      local.action_create_log_stream,
      local.action_put_log_events,
      local.action_create_log_group,
    ]

    resources = ["${aws_cloudwatch_log_group.application.arn}:*"]
  }
}
