# Lambda Extension Constants (AWS-defined, cannot be changed)
locals {
  lambda_extension = {
    # Extension environment variable names (AWS-defined)
    env_var_names = {
      http_port       = "PARAMETERS_SECRETS_EXTENSION_HTTP_PORT"
      cache_enabled   = "PARAMETERS_SECRETS_EXTENSION_CACHE_ENABLED"
      cache_size      = "PARAMETERS_SECRETS_EXTENSION_CACHE_SIZE"
      max_connections = "PARAMETERS_SECRETS_EXTENSION_MAX_CONNECTIONS"
      secrets_timeout = "SECRETS_MANAGER_TIMEOUT_MILLIS"
      ssm_timeout     = "SSM_PARAMETER_STORE_TIMEOUT_MILLIS"
    }

    # Layer versioning (AWS-managed)
    layer = {
      version            = 11
      name_x86_64        = "AWS-Parameters-and-Secrets-Lambda-Extension"
      name_arm64         = "AWS-Parameters-and-Secrets-Lambda-Extension-Arm64"
      arn_pattern_x86_64 = "arn:aws:lambda:%s:%s:layer:AWS-Parameters-and-Secrets-Lambda-Extension:%d"
      arn_pattern_arm64  = "arn:aws:lambda:%s:%s:layer:AWS-Parameters-and-Secrets-Lambda-Extension-Arm64:%d"
    }
  }
}
