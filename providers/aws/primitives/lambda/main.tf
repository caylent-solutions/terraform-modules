data "aws_region" "current" {
  count = var.enable_parameters_and_secrets_extension ? 1 : 0
}

data "aws_partition" "current" {
  count = var.enable_parameters_and_secrets_extension ? 1 : 0
}

data "aws_ssm_parameter" "this" {
  for_each = var.environment_from_ssm

  name = each.value
}

data "aws_secretsmanager_secret_version" "this" {
  for_each = var.environment_from_secrets

  secret_id = each.value
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  description   = var.description
  role          = var.role
  publish       = var.publish

  package_type = var.package_type

  # Zip package type - local file
  filename         = var.package_type == "Zip" && var.filename != null ? var.filename : null
  source_code_hash = var.package_type == "Zip" ? var.source_code_hash : null

  # Zip package type - S3 object
  s3_bucket         = var.package_type == "Zip" && var.s3_bucket != null ? var.s3_bucket : null
  s3_key            = var.package_type == "Zip" && var.s3_key != null ? var.s3_key : null
  s3_object_version = var.package_type == "Zip" && var.s3_object_version != null ? var.s3_object_version : null

  handler = var.package_type == "Zip" ? var.handler : null
  runtime = var.package_type == "Zip" ? var.runtime : null
  layers  = var.package_type == "Zip" ? local.all_layers : null

  # Image package type
  image_uri = var.package_type == "Image" ? var.image_uri : null

  dynamic "image_config" {
    for_each = var.package_type == "Image" && var.image_config != null ? [var.image_config] : []
    content {
      command           = lookup(image_config.value, "command", null)
      entry_point       = lookup(image_config.value, "entry_point", null)
      working_directory = lookup(image_config.value, "working_directory", null)
    }
  }

  architectures                  = var.architectures
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions

  kms_key_arn             = var.kms_key_arn
  code_signing_config_arn = var.code_signing_config_arn

  dynamic "environment" {
    for_each = local.has_environment ? [local.merged_env] : []
    content {
      variables = environment.value
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config != null ? [var.dead_letter_config] : []
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  dynamic "file_system_config" {
    for_each = var.file_system_config != null ? [var.file_system_config] : []
    content {
      arn              = file_system_config.value.arn
      local_mount_path = file_system_config.value.local_mount_path
    }
  }

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size != null ? [var.ephemeral_storage_size] : []
    content {
      size = ephemeral_storage.value
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      log_format            = logging_config.value.log_format
      log_group             = lookup(logging_config.value, "log_group", null)
      system_log_level      = lookup(logging_config.value, "system_log_level", null)
      application_log_level = lookup(logging_config.value, "application_log_level", null)
    }
  }

  tracing_config {
    mode = var.tracing_mode
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_event_source_mapping" "this" {
  for_each = var.event_source_mappings

  event_source_arn  = each.value.event_source_arn
  function_name     = aws_lambda_function.this.arn
  batch_size        = lookup(each.value, "batch_size", var.default_batch_size)
  enabled           = lookup(each.value, "enabled", var.default_enabled)
  starting_position = lookup(each.value, "starting_position", null)

  maximum_batching_window_in_seconds = lookup(each.value, "maximum_batching_window_in_seconds", null)

  dynamic "filter_criteria" {
    for_each = lookup(each.value, "filter_criteria", null) != null ? [each.value.filter_criteria] : []
    content {
      dynamic "filter" {
        for_each = filter_criteria.value.filters
        content {
          pattern = lookup(filter.value, "pattern", null)
        }
      }
    }
  }

  dynamic "scaling_config" {
    for_each = lookup(each.value, "scaling_config", null) != null ? [each.value.scaling_config] : []
    content {
      maximum_concurrency = scaling_config.value.maximum_concurrency
    }
  }
}

resource "aws_lambda_permission" "this" {
  for_each = var.permissions

  statement_id       = each.value.statement_id
  action             = each.value.action
  function_name      = aws_lambda_function.this.function_name
  principal          = each.value.principal
  source_arn         = lookup(each.value, "source_arn", null)
  source_account     = lookup(each.value, "source_account", null)
  event_source_token = lookup(each.value, "event_source_token", null)
}

resource "aws_lambda_provisioned_concurrency_config" "this" {
  for_each = var.provisioned_concurrent_executions

  function_name                     = aws_lambda_function.this.function_name
  provisioned_concurrent_executions = each.value.provisioned_concurrent_executions
  qualifier                         = each.value.qualifier == "$LATEST" ? each.value.qualifier : (var.publish ? aws_lambda_function.this.version : each.value.qualifier)
}

resource "aws_lambda_function_url" "this" {
  for_each = var.function_urls

  function_name      = aws_lambda_function.this.function_name
  authorization_type = each.value.authorization_type
  qualifier          = lookup(each.value, "qualifier", null)

  dynamic "cors" {
    for_each = lookup(each.value, "cors", null) != null ? [each.value.cors] : []
    content {
      allow_credentials = lookup(cors.value, "allow_credentials", null)
      allow_headers     = lookup(cors.value, "allow_headers", null)
      allow_methods     = lookup(cors.value, "allow_methods", null)
      allow_origins     = lookup(cors.value, "allow_origins", null)
      expose_headers    = lookup(cors.value, "expose_headers", null)
      max_age           = lookup(cors.value, "max_age", null)
    }
  }
}

resource "aws_lambda_alias" "this" {
  for_each = var.aliases

  name             = each.key
  function_name    = aws_lambda_function.this.function_name
  function_version = var.publish ? aws_lambda_function.this.version : each.value.function_version
  description      = lookup(each.value, "description", null)

  dynamic "routing_config" {
    for_each = lookup(each.value, "routing_config", null) != null ? [each.value.routing_config] : []
    content {
      additional_version_weights = routing_config.value.additional_version_weights
    }
  }
}

resource "aws_lambda_function_event_invoke_config" "this" {
  for_each = var.event_invoke_configs

  function_name = aws_lambda_function.this.function_name
  qualifier     = lookup(each.value, "qualifier", null)

  maximum_event_age_in_seconds = lookup(each.value, "maximum_event_age_in_seconds", null)
  maximum_retry_attempts       = lookup(each.value, "maximum_retry_attempts", null)

  dynamic "destination_config" {
    for_each = lookup(each.value, "destination_config", null) != null ? [each.value.destination_config] : []
    content {
      dynamic "on_failure" {
        for_each = lookup(destination_config.value, "on_failure", null) != null ? [destination_config.value.on_failure] : []
        content {
          destination = on_failure.value.destination
        }
      }
      dynamic "on_success" {
        for_each = lookup(destination_config.value, "on_success", null) != null ? [destination_config.value.on_success] : []
        content {
          destination = on_success.value.destination
        }
      }
    }
  }
}

resource "aws_lambda_layer_version" "this" {
  for_each = var.layer_versions

  layer_name          = each.key
  filename            = lookup(each.value, "filename", null)
  s3_bucket           = lookup(each.value, "s3_bucket", null)
  s3_key              = lookup(each.value, "s3_key", null)
  s3_object_version   = lookup(each.value, "s3_object_version", null)
  compatible_runtimes = lookup(each.value, "compatible_runtimes", null)
  description         = lookup(each.value, "description", null)
  license_info        = lookup(each.value, "license_info", null)
}
