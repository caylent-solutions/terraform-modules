module "opensearch" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/opensearch-domain?ref=providers/aws/primitives/opensearch-domain/v0.1.0"

  domain_name              = var.opensearch_domain_name
  engine_version           = var.opensearch_engine_version
  instance_type            = var.opensearch_instance_type
  instance_count           = var.opensearch_instance_count
  dedicated_master_enabled = var.opensearch_dedicated_master_enabled
  dedicated_master_type    = var.opensearch_dedicated_master_type
  dedicated_master_count   = var.opensearch_dedicated_master_count
  zone_awareness_enabled   = var.opensearch_zone_awareness_enabled
  availability_zone_count  = var.opensearch_availability_zone_count
  ebs_volume_type          = var.opensearch_ebs_volume_type
  ebs_volume_size          = var.opensearch_ebs_volume_size
  kms_key_id               = var.opensearch_kms_key_id
  tls_security_policy      = var.opensearch_tls_security_policy
  vpc_subnet_ids           = var.opensearch_vpc_subnet_ids
  vpc_security_group_ids   = var.opensearch_vpc_security_group_ids
  access_policies_json     = var.opensearch_access_policies_json
  log_retention_in_days    = var.opensearch_log_retention_in_days
  log_kms_key_arn          = var.opensearch_log_kms_key_arn

  tags = var.tags
}

module "grafana" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/managed-grafana-workspace?ref=providers/aws/primitives/managed-grafana-workspace/v0.1.0"

  workspace_name            = var.grafana_workspace_name
  description               = var.grafana_description
  account_access_type       = var.grafana_account_access_type
  authentication_providers  = var.grafana_authentication_providers
  permission_type           = var.grafana_permission_type
  data_sources              = var.grafana_data_sources
  notification_destinations = var.grafana_notification_destinations
  admin_sso_group_ids       = var.grafana_admin_sso_group_ids
  editor_sso_group_ids      = var.grafana_editor_sso_group_ids
  viewer_sso_group_ids      = var.grafana_viewer_sso_group_ids
  vpc_configuration         = var.grafana_vpc_configuration

  tags = var.tags
}

module "indexer" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/lambda?ref=providers/aws/primitives/lambda/v0.1.0"

  function_name = var.indexer_function_name
  description   = var.indexer_description
  role          = var.indexer_role_arn
  package_type  = var.indexer_package_type
  filename      = var.indexer_filename
  s3_bucket     = var.indexer_s3_bucket
  s3_key        = var.indexer_s3_key
  image_uri     = var.indexer_image_uri
  handler       = var.indexer_handler
  runtime       = var.indexer_runtime
  memory_size   = var.indexer_memory_size
  timeout       = var.indexer_timeout
  environment   = length(var.indexer_environment) == 0 ? null : { variables = var.indexer_environment }

  tags = var.tags
}
