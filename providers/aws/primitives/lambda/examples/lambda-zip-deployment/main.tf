data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/function.py"
  output_path = "${path.module}/function.zip"
}

resource "aws_s3_bucket" "lambda_artifacts" {
  bucket_prefix = "${var.function_name}-artifacts-"
  force_destroy = true
}

resource "aws_s3_object" "lambda_package" {
  bucket = aws_s3_bucket.lambda_artifacts.id
  key    = "function-${data.archive_file.lambda.output_base64sha256}.zip"
  source = data.archive_file.lambda.output_path
  etag   = filemd5(data.archive_file.lambda.output_path)
}

resource "aws_iam_role" "lambda" {
  name = "${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_sqs_queue" "test" {
  name = "${var.function_name}-queue"
}

resource "aws_sqs_queue" "dlq" {
  name = "${var.function_name}-dlq"
}

resource "aws_sns_topic" "success" {
  name = "${var.function_name}-success"
}

resource "aws_sns_topic" "failure" {
  name = "${var.function_name}-failure"
}

resource "aws_iam_role_policy" "lambda_sqs" {
  name = "${var.function_name}-sqs-policy"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:SendMessage"
      ]
      Resource = [aws_sqs_queue.test.arn, aws_sqs_queue.dlq.arn]
      }, {
      Effect = "Allow"
      Action = [
        "sns:Publish"
      ]
      Resource = [aws_sns_topic.success.arn, aws_sns_topic.failure.arn]
    }]
  })
}

resource "aws_kms_key" "lambda" {
  description = "KMS key for Lambda environment variables"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_ssm_parameter" "api_key" {
  name  = "/${var.function_name}/api/key/${random_id.suffix.hex}"
  type  = "SecureString"
  value = var.ssm_api_key_value
}

resource "aws_secretsmanager_secret" "db_creds" {
  name                    = "${var.function_name}-db-creds-${random_id.suffix.hex}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_creds" {
  secret_id     = aws_secretsmanager_secret.db_creds.id
  secret_string = var.db_secret_string
}

resource "aws_iam_role_policy" "lambda_ssm_secrets" {
  name = "${var.function_name}-ssm-secrets-policy"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = [aws_ssm_parameter.api_key.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [aws_secretsmanager_secret.db_creds.arn]
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
}

module "lambda" {
  source = "../../"

  function_name = var.function_name
  description   = "Comprehensive Lambda Zip deployment example"
  role          = aws_iam_role.lambda.arn
  package_type  = "Zip"
  publish       = true

  # S3 deployment method
  s3_bucket        = aws_s3_bucket.lambda_artifacts.id
  s3_key           = aws_s3_object.lambda_package.key
  source_code_hash = data.archive_file.lambda.output_base64sha256
  handler          = "function.lambda_handler"
  runtime          = "python3.12"

  timeout                        = 30
  memory_size                    = 512
  reserved_concurrent_executions = 5
  ephemeral_storage_size         = 1024

  kms_key_arn = aws_kms_key.lambda.arn

  environment = {
    variables = {
      LOG_LEVEL = "INFO"
      ENV       = "test"
    }
  }

  environment_from_ssm = {
    API_KEY = aws_ssm_parameter.api_key.name
  }

  environment_from_secrets = {
    DB_CREDS = aws_secretsmanager_secret.db_creds.arn
  }

  dead_letter_config = {
    target_arn = aws_sqs_queue.dlq.arn
  }

  logging_config = {
    log_format            = "JSON"
    log_group             = aws_cloudwatch_log_group.lambda.name
    application_log_level = "INFO"
    system_log_level      = "INFO"
  }

  tracing_mode = "Active"

  event_source_mappings = {
    sqs = {
      event_source_arn                   = aws_sqs_queue.test.arn
      batch_size                         = 10
      maximum_batching_window_in_seconds = 5
      filter_criteria = {
        filters = [
          { pattern = jsonencode({ body = { type = ["order"] } }) }
        ]
      }
      scaling_config = {
        maximum_concurrency = 5
      }
    }
  }

  permissions = {
    sqs = {
      statement_id   = "AllowSQSInvoke"
      action         = "lambda:InvokeFunction"
      principal      = "sqs.amazonaws.com"
      source_arn     = aws_sqs_queue.test.arn
      source_account = data.aws_caller_identity.current.account_id
    }
  }

  provisioned_concurrent_executions = {
    prod = {
      provisioned_concurrent_executions = 2
      qualifier                         = "1"
    }
  }

  function_urls = {
    default = {
      authorization_type = "NONE"
      cors = {
        allow_origins = ["*"]
        allow_methods = ["GET", "POST"]
        max_age       = 86400
      }
    }
  }

  aliases = {
    prod = {
      function_version = "1"
      description      = "Production alias"
    }
  }

  event_invoke_configs = {
    default = {
      maximum_retry_attempts       = 1
      maximum_event_age_in_seconds = 3600
      destination_config = {
        on_success = {
          destination = aws_sns_topic.success.arn
        }
        on_failure = {
          destination = aws_sns_topic.failure.arn
        }
      }
    }
  }

  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_secretsmanager_secret_version.db_creds
  ]
}

data "aws_caller_identity" "current" {}
