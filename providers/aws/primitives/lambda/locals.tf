locals {
  # Merge environment variables from all sources
  env_from_static  = var.environment != null ? var.environment.variables : {}
  env_from_ssm     = { for k, v in var.environment_from_ssm : k => data.aws_ssm_parameter.this[k].value }
  env_from_secrets = { for k, v in var.environment_from_secrets : k => data.aws_secretsmanager_secret_version.this[k].secret_string }

  # Extension constants from data module
  ext = module.aws_data.lambda_extension

  # Parameters and Secrets Lambda Extension configuration
  extension_env = var.enable_parameters_and_secrets_extension ? {
    (local.ext.env_var_names.http_port)       = tostring(var.parameters_and_secrets_extension_config.http_port)
    (local.ext.env_var_names.cache_enabled)   = var.parameters_and_secrets_extension_config.cache_enabled
    (local.ext.env_var_names.cache_size)      = var.parameters_and_secrets_extension_config.cache_size
    (local.ext.env_var_names.max_connections) = tostring(var.parameters_and_secrets_extension_config.max_connections)
    (local.ext.env_var_names.secrets_timeout) = tostring(var.parameters_and_secrets_extension_config.secrets_manager_timeout)
    (local.ext.env_var_names.ssm_timeout)     = tostring(var.parameters_and_secrets_extension_config.ssm_parameter_store_timeout)
  } : {}

  merged_env = merge(
    local.env_from_static,
    local.env_from_ssm,
    local.env_from_secrets,
    local.extension_env
  )

  has_environment = length(local.merged_env) > 0

  # AWS Parameters and Secrets Lambda Extension Layer ARN
  extension_layer_arn = var.enable_parameters_and_secrets_extension ? (
    contains(var.architectures, "arm64") ?
    format(local.ext.layer.arn_pattern_arm64, data.aws_region.current[0].name, data.aws_partition.current[0].id, local.ext.layer.version) :
    format(local.ext.layer.arn_pattern_x86_64, data.aws_region.current[0].name, data.aws_partition.current[0].id, local.ext.layer.version)
  ) : null

  # Merge layers with extension layer
  all_layers = var.enable_parameters_and_secrets_extension && local.extension_layer_arn != null ? (
    var.layers != null ? concat(var.layers, [local.extension_layer_arn]) : [local.extension_layer_arn]
  ) : var.layers
}
