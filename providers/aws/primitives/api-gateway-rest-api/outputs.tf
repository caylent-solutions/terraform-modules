output "rest_api_id" {
  description = "ID of the REST API."
  value       = aws_api_gateway_rest_api.this.id
}

output "rest_api_arn" {
  description = "ARN of the REST API."
  value       = aws_api_gateway_rest_api.this.arn
}

output "rest_api_root_resource_id" {
  description = "Resource ID of the REST API's root (`/`) resource."
  value       = aws_api_gateway_rest_api.this.root_resource_id
}

output "rest_api_execution_arn" {
  description = "Execution ARN prefix used for granting `lambda:InvokeFunction` permissions to API Gateway."
  value       = aws_api_gateway_rest_api.this.execution_arn
}

output "stage_name" {
  description = "Name of the deployment stage."
  value       = aws_api_gateway_stage.this.stage_name
}

output "stage_arn" {
  description = "ARN of the deployment stage."
  value       = aws_api_gateway_stage.this.arn
}

output "stage_invoke_url" {
  description = "Invocation URL of the deployment stage on the default execute-api endpoint."
  value       = aws_api_gateway_stage.this.invoke_url
}

output "deployment_id" {
  description = "ID of the deployment associated with the stage."
  value       = aws_api_gateway_deployment.this.id
}

output "access_log_group_arn" {
  description = "ARN of the auto-created access log group, or null when create_access_log_group is false."
  value       = var.create_access_log_group && var.access_log_destination_arn == null ? aws_cloudwatch_log_group.stage_access[0].arn : null
}

output "custom_domain_regional_domain_name" {
  description = "Regional domain name created for the custom domain, or null when custom_domain_name is not set."
  value       = var.custom_domain_name == null ? null : aws_api_gateway_domain_name.this[0].regional_domain_name
}

output "custom_domain_regional_zone_id" {
  description = "Regional zone ID for the custom domain (used for Route53 alias records), or null when not set."
  value       = var.custom_domain_name == null ? null : aws_api_gateway_domain_name.this[0].regional_zone_id
}

output "usage_plan_id" {
  description = "ID of the usage plan, or null when create_usage_plan is false."
  value       = var.create_usage_plan ? aws_api_gateway_usage_plan.this[0].id : null
}
