output "function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda.function_name
}

output "function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = module.lambda.invoke_arn
}

output "function_version" {
  description = "Version of the Lambda function"
  value       = module.lambda.version
}

output "event_source_mapping_uuid" {
  description = "UUID of the event source mapping"
  value       = try(module.lambda.event_source_mapping_uuids["sqs"], null)
}

output "event_source_mapping_state" {
  description = "State of the event source mapping"
  value       = try(module.lambda.event_source_mapping_states["sqs"], null)
}

output "function_url" {
  description = "Function URL endpoint"
  value       = try(module.lambda.function_urls["default"], null)
}

output "alias_arn" {
  description = "ARN of the prod alias"
  value       = try(module.lambda.alias_arns["prod"], null)
}

output "provisioned_concurrency_id" {
  description = "ID of provisioned concurrency config"
  value       = try(module.lambda.provisioned_concurrency_configs["prod"], null)
}

output "s3_bucket" {
  description = "S3 bucket containing Lambda deployment package"
  value       = aws_s3_bucket.lambda_artifacts.id
}

output "s3_key" {
  description = "S3 key of Lambda deployment package"
  value       = aws_s3_object.lambda_package.key
}
