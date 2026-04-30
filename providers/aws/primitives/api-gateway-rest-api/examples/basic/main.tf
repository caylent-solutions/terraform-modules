resource "aws_cloudwatch_log_group" "api_access_logs" {
  name              = var.access_log_group_name
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}

module "api_gateway_rest_api" {
  source = "../../"

  name       = var.name
  stage_name = var.stage_name

  description              = var.description
  endpoint_type            = var.endpoint_type
  minimum_compression_size = var.minimum_compression_size
  xray_tracing_enabled     = var.xray_tracing_enabled
  metrics_enabled          = var.metrics_enabled
  logging_level            = var.logging_level
  throttling_burst_limit   = var.throttling_burst_limit
  throttling_rate_limit    = var.throttling_rate_limit

  access_log_destination_arn = aws_cloudwatch_log_group.api_access_logs.arn

  tags = var.tags
}

output "rest_api_id" {
  description = "The ID of the REST API."
  value       = module.api_gateway_rest_api.rest_api_id
}

output "rest_api_arn" {
  description = "The ARN of the REST API."
  value       = module.api_gateway_rest_api.rest_api_arn
}

output "rest_api_execution_arn" {
  description = "The execution ARN of the REST API."
  value       = module.api_gateway_rest_api.rest_api_execution_arn
}

output "rest_api_root_resource_id" {
  description = "The root resource ID of the REST API."
  value       = module.api_gateway_rest_api.rest_api_root_resource_id
}

output "stage_id" {
  description = "The ID of the stage."
  value       = module.api_gateway_rest_api.stage_id
}

output "stage_arn" {
  description = "The ARN of the stage."
  value       = module.api_gateway_rest_api.stage_arn
}

output "stage_invoke_url" {
  description = "The URL to invoke the API."
  value       = module.api_gateway_rest_api.stage_invoke_url
}

output "stage_execution_arn" {
  description = "The execution ARN of the stage."
  value       = module.api_gateway_rest_api.stage_execution_arn
}

output "access_log_group_arn" {
  description = "The ARN of the CloudWatch log group for API access logs."
  value       = aws_cloudwatch_log_group.api_access_logs.arn
}
