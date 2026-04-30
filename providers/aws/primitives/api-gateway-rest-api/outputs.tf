output "rest_api_id" {
  description = "The ID of the REST API."
  value       = aws_api_gateway_rest_api.this.id
}

output "rest_api_arn" {
  description = "The ARN of the REST API."
  value       = aws_api_gateway_rest_api.this.arn
}

output "rest_api_execution_arn" {
  description = "The execution ARN part to be used in lambda_permission's source_arn."
  value       = aws_api_gateway_rest_api.this.execution_arn
}

output "rest_api_root_resource_id" {
  description = "The resource ID of the REST API's root resource."
  value       = aws_api_gateway_rest_api.this.root_resource_id
}

output "deployment_id" {
  description = "The ID of the API deployment."
  value       = aws_api_gateway_deployment.this.id
}

output "stage_id" {
  description = "The ID of the stage."
  value       = aws_api_gateway_stage.this.id
}

output "stage_arn" {
  description = "The ARN of the stage."
  value       = aws_api_gateway_stage.this.arn
}

output "stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage."
  value       = aws_api_gateway_stage.this.invoke_url
}

output "stage_execution_arn" {
  description = "The execution ARN to be used in lambda_permission's source_arn when allowing API Gateway to invoke a Lambda function."
  value       = aws_api_gateway_stage.this.execution_arn
}

output "domain_name_id" {
  description = "The internal ID assigned to the custom domain name resource."
  value       = local.create_domain ? aws_api_gateway_domain_name.this[0].id : null
}

output "domain_name_arn" {
  description = "The ARN of the custom domain name."
  value       = local.create_domain ? aws_api_gateway_domain_name.this[0].arn : null
}

output "domain_regional_domain_name" {
  description = "The hostname for the custom domain's regional endpoint."
  value       = local.create_domain ? aws_api_gateway_domain_name.this[0].regional_domain_name : null
}

output "domain_regional_zone_id" {
  description = "The hosted zone ID that can be used to create an Alias record pointing to the regional endpoint."
  value       = local.create_domain ? aws_api_gateway_domain_name.this[0].regional_zone_id : null
}

output "usage_plan_id" {
  description = "The ID of the usage plan."
  value       = local.create_usage_plan ? aws_api_gateway_usage_plan.this[0].id : null
}

output "usage_plan_arn" {
  description = "The ARN of the usage plan."
  value       = local.create_usage_plan ? aws_api_gateway_usage_plan.this[0].arn : null
}
