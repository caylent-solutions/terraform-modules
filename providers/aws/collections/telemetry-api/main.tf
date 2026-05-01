module "waf" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/waf-webacl?ref=providers/aws/primitives/waf-webacl/v0.1.0"

  name                       = var.web_acl_name
  description                = var.web_acl_description
  scope                      = var.web_acl_scope
  default_action             = var.web_acl_default_action
  managed_rule_groups        = var.web_acl_managed_rule_groups
  rate_limit_per_ip          = var.web_acl_rate_limit_per_ip
  rate_limit_per_header      = var.web_acl_rate_limit_per_header
  cloudwatch_metrics_enabled = var.web_acl_cloudwatch_metrics_enabled
  sampled_requests_enabled   = var.web_acl_sampled_requests_enabled
  logging_enabled            = var.web_acl_logging_enabled
  create_log_group           = var.web_acl_create_log_group
  log_destination_arn        = var.web_acl_log_destination_arn
  log_retention_in_days      = var.web_acl_log_retention_in_days
  log_kms_key_arn            = var.web_acl_log_kms_key_arn

  tags = var.tags
}

module "lambda_authorizer" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/lambda?ref=providers/aws/primitives/lambda/v0.1.0"

  function_name = var.authorizer_function_name
  description   = var.authorizer_description
  role          = var.authorizer_role_arn
  package_type  = var.authorizer_package_type
  filename      = var.authorizer_filename
  s3_bucket     = var.authorizer_s3_bucket
  s3_key        = var.authorizer_s3_key
  image_uri     = var.authorizer_image_uri
  handler       = var.authorizer_handler
  runtime       = var.authorizer_runtime
  memory_size   = var.authorizer_memory_size
  timeout       = var.authorizer_timeout
  environment   = length(var.authorizer_environment) == 0 ? null : { variables = var.authorizer_environment }

  tags = var.tags
}

module "api" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/api-gateway-rest-api?ref=providers/aws/primitives/api-gateway-rest-api/v0.1.0"

  name                          = var.api_name
  description                   = var.api_description
  openapi_body                  = var.api_openapi_body
  endpoint_type                 = var.api_endpoint_type
  stage_name                    = var.api_stage_name
  stage_description             = var.api_stage_description
  xray_tracing_enabled          = var.api_xray_tracing_enabled
  cache_cluster_enabled         = var.api_cache_cluster_enabled
  cache_cluster_size            = var.api_cache_cluster_size
  method_logging_level          = var.api_method_logging_level
  method_metrics_enabled        = var.api_method_metrics_enabled
  method_throttling_burst_limit = var.api_method_throttling_burst_limit
  method_throttling_rate_limit  = var.api_method_throttling_rate_limit
  create_access_log_group       = var.api_create_access_log_group
  access_log_destination_arn    = var.api_access_log_destination_arn
  access_log_retention_in_days  = var.api_access_log_retention_in_days
  access_log_kms_key_arn        = var.api_access_log_kms_key_arn
  custom_domain_name            = var.custom_domain_name
  custom_domain_certificate_arn = var.custom_domain_certificate_arn
  custom_domain_security_policy = var.custom_domain_security_policy
  custom_domain_base_path       = var.custom_domain_base_path

  tags = var.tags
}

module "custom_domain_record" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/route53-record?ref=providers/aws/primitives/route53-record/v0.1.0"

  count = local.custom_domain_record_count

  zone_id = var.route53_zone_id
  name    = var.custom_domain_name
  type    = local.alias_record_type

  alias = {
    name                   = module.api.custom_domain_regional_domain_name
    zone_id                = module.api.custom_domain_regional_zone_id
    evaluate_target_health = local.alias_evaluate_target_health
  }
}
