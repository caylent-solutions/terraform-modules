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

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.lambda.repository_url
}

output "layer_version_arn" {
  description = "ARN of the custom layer"
  value       = try(module.lambda.layer_version_arns["custom"], null)
}

output "efs_file_system_id" {
  description = "ID of the EFS file system"
  value       = aws_efs_file_system.lambda.id
}

output "function_architecture" {
  description = "Instruction set architecture of the Lambda function"
  value       = one(module.lambda.architectures)
}
