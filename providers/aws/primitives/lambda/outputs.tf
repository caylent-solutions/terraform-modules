output "arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "invoke_arn" {
  description = "ARN to be used for invoking Lambda function from API Gateway"
  value       = aws_lambda_function.this.invoke_arn
}

output "qualified_arn" {
  description = "ARN identifying your Lambda function version"
  value       = aws_lambda_function.this.qualified_arn
}

output "version" {
  description = "Latest published version of your Lambda function"
  value       = aws_lambda_function.this.version
}

output "last_modified" {
  description = "Date the function was last modified"
  value       = aws_lambda_function.this.last_modified
}

output "source_code_size" {
  description = "Size of the function deployment package in bytes"
  value       = aws_lambda_function.this.source_code_size
}

output "code_sha256" {
  description = "Base64-encoded SHA256 hash of the package"
  value       = aws_lambda_function.this.source_code_hash
}

output "event_source_mapping_uuids" {
  description = "Map of event source mapping UUIDs"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.uuid }
}

output "event_source_mapping_states" {
  description = "Map of event source mapping states"
  value       = { for k, v in aws_lambda_event_source_mapping.this : k => v.state }
}

output "provisioned_concurrency_configs" {
  description = "Map of provisioned concurrency configuration ARNs"
  value       = { for k, v in aws_lambda_provisioned_concurrency_config.this : k => v.id }
}

output "function_urls" {
  description = "Map of function URL endpoints"
  value       = { for k, v in aws_lambda_function_url.this : k => v.function_url }
}

output "alias_arns" {
  description = "Map of alias ARNs"
  value       = { for k, v in aws_lambda_alias.this : k => v.arn }
}

output "alias_invoke_arns" {
  description = "Map of alias invoke ARNs"
  value       = { for k, v in aws_lambda_alias.this : k => v.invoke_arn }
}

output "layer_version_arns" {
  description = "Map of layer version ARNs"
  value       = { for k, v in aws_lambda_layer_version.this : k => v.arn }
}

output "architectures" {
  description = "Instruction set architecture list for the Lambda function"
  value       = aws_lambda_function.this.architectures
}

output "tracing_mode" {
  description = "X-Ray tracing mode configured for the Lambda function"
  value       = var.tracing_mode
}
