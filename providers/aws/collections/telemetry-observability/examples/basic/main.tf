resource "random_id" "suffix" {
  byte_length = 4
}

# Indexer Lambda role -- least-privilege CloudWatch Logs writes only.
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

resource "aws_iam_role" "indexer" {
  name_prefix = "${var.indexer_function_name}-${random_id.suffix.hex}-"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "indexer_logs" {
  role       = aws_iam_role.indexer.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Minimal indexer code -- production deploys ship the real bulk-index handler;
# this example only needs a deployable artifact so the collection composes.
data "archive_file" "indexer" {
  type        = "zip"
  output_path = "${path.module}/.indexer.zip"

  source {
    filename = "index.js"
    content  = "exports.handler = async () => ({ statusCode: 200 });\n"
  }
}

module "telemetry_observability" {
  source = "../../"

  opensearch_domain_name    = "${var.opensearch_domain_name}-${random_id.suffix.hex}"
  opensearch_engine_version = var.opensearch_engine_version
  opensearch_instance_type  = var.opensearch_instance_type

  grafana_workspace_name           = "${var.grafana_workspace_name}-${random_id.suffix.hex}"
  grafana_authentication_providers = var.grafana_authentication_providers
  grafana_data_sources             = var.grafana_data_sources

  indexer_function_name = "${var.indexer_function_name}-${random_id.suffix.hex}"
  indexer_role_arn      = aws_iam_role.indexer.arn
  indexer_filename      = data.archive_file.indexer.output_path
  indexer_handler       = "index.handler"
  indexer_runtime       = "nodejs20.x"

  tags = var.tags
}
