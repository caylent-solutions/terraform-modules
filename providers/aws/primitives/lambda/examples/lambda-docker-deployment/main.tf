resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_ecr_repository" "lambda" {
  name         = "${var.function_name}-${random_id.suffix.hex}"
  force_delete = true
}

resource "null_resource" "docker_build_push" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/build-and-push.sh ${data.aws_region.current.name} ${aws_ecr_repository.lambda.repository_url} latest ${path.module}"
  }

  depends_on = [aws_ecr_repository.lambda]
}

data "aws_region" "current" {}

resource "aws_iam_role" "lambda" {
  name = "${var.function_name}-role-${random_id.suffix.hex}"

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

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_ssm_parameter" "config" {
  name  = "/${var.function_name}-${random_id.suffix.hex}/config/setting"
  type  = "String"
  value = "production-config"
}

resource "aws_secretsmanager_secret" "api_token" {
  name                    = "${var.function_name}-api-token-${random_id.suffix.hex}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "api_token" {
  secret_id     = aws_secretsmanager_secret.api_token.id
  secret_string = "secret-token-xyz"
}

resource "aws_iam_role_policy" "lambda_extension" {
  name = "${var.function_name}-extension-policy"
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
        Resource = [aws_ssm_parameter.config.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [aws_secretsmanager_secret.api_token.arn]
      }
    ]
  })
}

resource "aws_vpc" "test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "test" {
  count             = 2
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_security_group" "lambda" {
  name   = "${var.function_name}-sg-${random_id.suffix.hex}"
  vpc_id = aws_vpc.test.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system" "lambda" {
  creation_token = "${var.function_name}-${random_id.suffix.hex}"
}

resource "aws_efs_mount_target" "lambda" {
  count           = 2
  file_system_id  = aws_efs_file_system.lambda.id
  subnet_id       = aws_subnet.test[count.index].id
  security_groups = [aws_security_group.lambda.id]
}

resource "aws_efs_access_point" "lambda" {
  file_system_id = aws_efs_file_system.lambda.id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    path = "/lambda"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "755"
    }
  }
}

resource "aws_signer_signing_profile" "lambda" {
  platform_id = "AWSLambda-SHA384-ECDSA"
}

resource "aws_lambda_code_signing_config" "lambda" {
  allowed_publishers {
    signing_profile_version_arns = [aws_signer_signing_profile.lambda.arn]
  }

  policies {
    untrusted_artifact_on_deployment = "Warn"
  }
}

data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "${path.module}/layer"
  output_path = "${path.module}/layer.zip"
}

module "lambda" {
  source = "../../"

  function_name = var.function_name
  description   = "Docker deployment with VPC, EFS, and code signing"
  role          = aws_iam_role.lambda.arn
  package_type  = "Image"
  publish       = false

  image_uri = "${aws_ecr_repository.lambda.repository_url}:latest"

  image_config = {
    command = ["app.handler"]
  }

  architectures                  = ["arm64"]
  timeout                        = 60
  memory_size                    = 2048
  reserved_concurrent_executions = -1
  ephemeral_storage_size         = 2048

  # Code signing not supported for container images
  # code_signing_config_arn = aws_lambda_code_signing_config.lambda.arn

  vpc_config = {
    subnet_ids         = aws_subnet.test[*].id
    security_group_ids = [aws_security_group.lambda.id]
  }

  file_system_config = {
    arn              = aws_efs_access_point.lambda.arn
    local_mount_path = "/mnt/efs"
  }

  tracing_mode = "PassThrough"

  enable_parameters_and_secrets_extension = true
  parameters_and_secrets_extension_config = {
    http_port                   = 2773
    secrets_manager_timeout     = 5000
    ssm_parameter_store_timeout = 5000
    max_connections             = 3
  }

  layer_versions = {
    custom = {
      filename            = data.archive_file.layer.output_path
      compatible_runtimes = ["python3.12"]
      description         = "Custom layer for Lambda"
    }
  }

  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Deployment  = "docker"
  }

  depends_on = [null_resource.docker_build_push, aws_efs_mount_target.lambda]
}

data "aws_availability_zones" "available" {
  state = "available"
}
