output "api_invoke_url" {
  description = "Invocation URL of the API Gateway stage."
  value       = module.telemetry_api.api_invoke_url
}

output "custom_domain_name" {
  description = "Custom domain name attached to the REST API (null for the basic example)."
  value       = module.telemetry_api.custom_domain_name
}

output "authorizer_function_name" {
  description = "Authorizer Lambda function name."
  value       = module.telemetry_api.authorizer_function_name
}

output "authorizer_function_arn" {
  description = "Authorizer Lambda function ARN."
  value       = module.telemetry_api.authorizer_function_arn
}

output "rest_api_id" {
  description = "ID of the REST API."
  value       = module.telemetry_api.rest_api_id
}

output "stage_name" {
  description = "Stage name of the deployed API."
  value       = module.telemetry_api.stage_name
}

output "stage_arn" {
  description = "Stage ARN (used for WAF association in the consumer)."
  value       = module.telemetry_api.stage_arn
}

output "web_acl_arn" {
  description = "ARN of the WAF Web ACL fronting the API."
  value       = module.telemetry_api.web_acl_arn
}
