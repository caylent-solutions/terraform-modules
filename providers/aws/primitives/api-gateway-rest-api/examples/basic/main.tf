resource "random_id" "suffix" {
  byte_length = 4
}

# API Gateway requires an account-level CloudWatch Logs role ARN
# before *any* stage-level logging (access or method) can be enabled.
# This is a per-account setting; provisioning it in the example lets
# the test exercise the access-log path end-to-end. Idempotent when
# the same role is set repeatedly.
resource "aws_iam_role" "apigw_cloudwatch" {
  count = var.create_account_cloudwatch_role ? 1 : 0

  name_prefix = "tt-apigw-cw-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "apigateway.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "apigw_cloudwatch" {
  count = var.create_account_cloudwatch_role ? 1 : 0

  role       = aws_iam_role.apigw_cloudwatch[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_account" "this" {
  count = var.create_account_cloudwatch_role ? 1 : 0

  cloudwatch_role_arn = aws_iam_role.apigw_cloudwatch[0].arn
}

# Minimal OpenAPI 3.0 body: a single `GET /` route that always returns
# HTTP 200 from a MOCK integration. Sufficient to exercise the full
# REST API + stage + deployment shape without provisioning a Lambda
# backend.
locals {
  openapi_body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = var.api_name
      version = "1.0"
    }
    paths = {
      "/" = {
        get = {
          responses = {
            "200" = { description = "OK" }
          }
          "x-amazon-apigateway-integration" = {
            type             = "mock"
            requestTemplates = { "application/json" = "{ \"statusCode\": 200 }" }
            responses = {
              default = {
                statusCode = "200"
                responseTemplates = {
                  "application/json" = "{ \"message\": \"hello from api-gateway-rest-api basic example\" }"
                }
              }
            }
            passthroughBehavior = "when_no_match"
          }
        }
      }
    }
  })
}

module "api" {
  source = "../../"

  depends_on = [aws_api_gateway_account.this]

  name        = "${var.api_name}-${random_id.suffix.hex}"
  description = "Basic example for api-gateway-rest-api primitive"

  endpoint_type = var.endpoint_type
  openapi_body  = local.openapi_body

  stage_name        = var.stage_name
  stage_description = "Basic example stage"

  xray_tracing_enabled   = var.xray_tracing_enabled
  method_logging_level   = var.method_logging_level
  method_metrics_enabled = var.method_metrics_enabled

  create_access_log_group      = var.create_access_log_group
  access_log_retention_in_days = var.access_log_retention_in_days

  create_usage_plan      = var.create_usage_plan
  usage_plan_description = var.create_usage_plan ? "Basic example usage plan" : null

  usage_plan_throttle = var.create_usage_plan ? {
    burst_limit = 50
    rate_limit  = 100
  } : null

  tags = var.tags
}

output "rest_api_id" {
  description = "ID of the REST API."
  value       = module.api.rest_api_id
}

output "rest_api_arn" {
  description = "ARN of the REST API."
  value       = module.api.rest_api_arn
}

output "stage_name" {
  description = "Stage name."
  value       = module.api.stage_name
}

output "stage_arn" {
  description = "Stage ARN."
  value       = module.api.stage_arn
}

output "stage_invoke_url" {
  description = "Stage invoke URL on the default execute-api endpoint."
  value       = module.api.stage_invoke_url
}

output "access_log_group_arn" {
  description = "Access log group ARN, or null when not created."
  value       = module.api.access_log_group_arn
}

output "usage_plan_id" {
  description = "Usage plan ID, or null when not created."
  value       = module.api.usage_plan_id
}
