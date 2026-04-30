resource "aws_api_gateway_rest_api" "this" {
  name                     = var.name
  description              = var.description
  binary_media_types       = var.binary_media_types
  minimum_compression_size = var.minimum_compression_size
  api_key_source           = var.api_key_source

  endpoint_configuration {
    types = [var.endpoint_type]
  }

  tags = local.common_tags
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = aws_api_gateway_rest_api.this.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id           = aws_api_gateway_rest_api.this.id
  deployment_id         = aws_api_gateway_deployment.this.id
  stage_name            = var.stage_name
  description           = var.stage_description
  variables             = var.stage_variables
  xray_tracing_enabled  = var.xray_tracing_enabled
  cache_cluster_enabled = var.cache_cluster_enabled
  cache_cluster_size    = var.cache_cluster_enabled ? var.cache_cluster_size : null

  access_log_settings {
    destination_arn = var.access_log_destination_arn
    format          = var.access_log_format
  }

  tags = local.common_tags
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = var._method_path_all

  settings {
    logging_level          = var.logging_level
    data_trace_enabled     = var.data_trace_enabled
    metrics_enabled        = var.metrics_enabled
    throttling_burst_limit = var.throttling_burst_limit
    throttling_rate_limit  = var.throttling_rate_limit
    caching_enabled        = var.cache_enabled
    cache_data_encrypted   = var.cache_data_encrypted
  }
}

resource "aws_api_gateway_account" "this" {
  count = var.cloudwatch_logs_role_arn != null ? 1 : 0

  cloudwatch_role_arn = var.cloudwatch_logs_role_arn
}

resource "aws_api_gateway_domain_name" "this" {
  count = local.create_domain ? 1 : 0

  domain_name              = var.domain_name
  regional_certificate_arn = var.domain_certificate_arn
  security_policy          = var.domain_security_policy

  endpoint_configuration {
    types = [var.endpoint_type]
  }

  tags = local.common_tags
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count = local.create_domain ? 1 : 0

  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.this[0].domain_name
  base_path   = var.base_path
}

resource "aws_wafv2_web_acl_association" "this" {
  count = local.create_waf ? 1 : 0

  resource_arn = aws_api_gateway_stage.this.arn
  web_acl_arn  = var.web_acl_arn
}

resource "aws_api_gateway_usage_plan" "this" {
  count = local.create_usage_plan ? 1 : 0

  name        = var.usage_plan_name
  description = var.usage_plan_description

  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_stage.this.stage_name
  }

  dynamic "quota_settings" {
    for_each = var.usage_plan_quota_limit != null ? [var.usage_plan_quota_limit] : []
    content {
      limit  = quota_settings.value
      offset = var.usage_plan_quota_offset
      period = var.usage_plan_quota_period
    }
  }

  dynamic "throttle_settings" {
    for_each = (var.usage_plan_throttle_burst_limit != null || var.usage_plan_throttle_rate_limit != null) ? [true] : []
    content {
      burst_limit = var.usage_plan_throttle_burst_limit
      rate_limit  = var.usage_plan_throttle_rate_limit
    }
  }

  tags = local.common_tags
}
