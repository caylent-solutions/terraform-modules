resource "random_id" "suffix" {
  byte_length = 4
}

# Authorizer Lambda role -- least-privilege CloudWatch Logs writes only.
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "authorizer" {
  name_prefix = "${var.web_acl_name}-authz-${random_id.suffix.hex}-"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "authorizer_logs" {
  role       = aws_iam_role.authorizer.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Minimal authorizer code -- a real deployment ships an HMAC-SHA256 verifier; this
# example just needs a deployable artifact so the collection can compose around it.
data "archive_file" "authorizer" {
  type        = "zip"
  output_path = "${path.module}/.authorizer.zip"

  source {
    filename = "index.js"
    content  = <<-EOT
      exports.handler = async (event) => ({
        principalId: "telemetry",
        policyDocument: {
          Version: "2012-10-17",
          Statement: [{ Action: "execute-api:Invoke", Effect: "Allow", Resource: "*" }]
        }
      });
    EOT
  }
}

# Minimal OpenAPI spec exercising a single POST /events route stubbed to a 200 mock.
locals {
  openapi_body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "telemetry-api-${random_id.suffix.hex}"
      version = "1.0"
    }
    paths = {
      "/events" = {
        post = {
          x-amazon-apigateway-integration = {
            type                = "mock"
            httpMethod          = "POST"
            requestTemplates    = { "application/json" = "{\"statusCode\": 200}" }
            responses           = { default = { statusCode = "200" } }
            passthroughBehavior = "when_no_match"
          }
          responses = { "200" = { description = "ok" } }
        }
      }
    }
  })
}

module "telemetry_api" {
  source = "../../"

  web_acl_name = "${var.web_acl_name}-${random_id.suffix.hex}"

  authorizer_function_name = "${var.authorizer_function_name}-${random_id.suffix.hex}"
  authorizer_role_arn      = aws_iam_role.authorizer.arn
  authorizer_filename      = data.archive_file.authorizer.output_path
  authorizer_handler       = "index.handler"
  authorizer_runtime       = "nodejs20.x"

  api_name         = "${var.api_name}-${random_id.suffix.hex}"
  api_openapi_body = local.openapi_body
  api_stage_name   = var.api_stage_name

  tags = var.tags
}
