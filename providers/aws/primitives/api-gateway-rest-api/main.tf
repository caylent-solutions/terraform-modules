resource "aws_api_gateway_rest_api" "this" {
  name        = var.name
  description = var.description
  body        = var.openapi_body

  endpoint_configuration {
    types = [var.endpoint_type]
  }

  minimum_compression_size     = var.minimum_compression_size
  binary_media_types           = var.binary_media_types
  api_key_source               = var.api_key_source
  disable_execute_api_endpoint = var.disable_execute_api_endpoint

  tags = var.tags
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode({
      body           = var.openapi_body
      endpoint_type  = var.endpoint_type
      stage_name     = var.stage_name
      api_key_source = var.api_key_source
    }))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "stage_access" {
  count = var.access_log_destination_arn == null && var.create_access_log_group ? 1 : 0

  name              = "${local.access_log_group_prefix}${var.name}/${var.stage_name}"
  retention_in_days = var.access_log_retention_in_days
  kms_key_id        = var.access_log_kms_key_arn

  tags = var.tags
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name
  deployment_id = aws_api_gateway_deployment.this.id
  description   = var.stage_description

  cache_cluster_enabled = var.cache_cluster_enabled
  cache_cluster_size    = var.cache_cluster_enabled ? var.cache_cluster_size : null

  xray_tracing_enabled = var.xray_tracing_enabled
  variables            = var.stage_variables

  dynamic "access_log_settings" {
    for_each = var.access_log_destination_arn != null || var.create_access_log_group ? [1] : []
    content {
      destination_arn = coalesce(var.access_log_destination_arn, try(aws_cloudwatch_log_group.stage_access[0].arn, null))
      format          = var.access_log_format
    }
  }

  tags = var.tags
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = local.method_path_all

  settings {
    metrics_enabled        = var.method_metrics_enabled
    logging_level          = var.method_logging_level
    data_trace_enabled     = var.method_data_trace_enabled
    throttling_burst_limit = var.method_throttling_burst_limit
    throttling_rate_limit  = var.method_throttling_rate_limit
    caching_enabled        = var.cache_cluster_enabled
    cache_data_encrypted   = var.cache_cluster_enabled ? local.always_enabled : null
  }
}

resource "aws_api_gateway_domain_name" "this" {
  count = var.custom_domain_name != null ? 1 : 0

  domain_name              = var.custom_domain_name
  regional_certificate_arn = var.custom_domain_certificate_arn
  security_policy          = var.custom_domain_security_policy

  endpoint_configuration {
    types = [var.endpoint_type]
  }

  tags = var.tags
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count = var.custom_domain_name != null ? 1 : 0

  api_id      = aws_api_gateway_rest_api.this.id
  domain_name = aws_api_gateway_domain_name.this[0].domain_name
  stage_name  = aws_api_gateway_stage.this.stage_name
  base_path   = var.custom_domain_base_path
}

resource "aws_api_gateway_usage_plan" "this" {
  count = var.create_usage_plan ? 1 : 0

  name        = "${var.name}${local.usage_plan_name_suffix}"
  description = var.usage_plan_description

  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_stage.this.stage_name
  }

  dynamic "throttle_settings" {
    for_each = var.usage_plan_throttle == null ? [] : [var.usage_plan_throttle]
    content {
      burst_limit = throttle_settings.value.burst_limit
      rate_limit  = throttle_settings.value.rate_limit
    }
  }

  dynamic "quota_settings" {
    for_each = var.usage_plan_quota == null ? [] : [var.usage_plan_quota]
    content {
      limit  = quota_settings.value.limit
      offset = lookup(quota_settings.value, "offset", null)
      period = quota_settings.value.period
    }
  }

  tags = var.tags
}
