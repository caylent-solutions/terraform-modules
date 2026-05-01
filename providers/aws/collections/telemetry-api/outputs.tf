output "api_invoke_url" {
  description = "Invocation URL of the REST API stage on the default execute-api endpoint."
  value       = module.api.stage_invoke_url
}

output "custom_domain_name" {
  description = "Custom domain name attached to the REST API, or null when not configured."
  value       = var.custom_domain_name
}

output "authorizer_function_name" {
  description = "Name of the HMAC-SHA256 authorizer Lambda function."
  value       = module.lambda_authorizer.function_name
}

output "authorizer_invoke_arn" {
  description = "Invoke ARN of the authorizer Lambda (for `x-amazon-apigateway-authorizer.authorizerUri`)."
  value       = module.lambda_authorizer.invoke_arn
}

output "authorizer_function_arn" {
  description = "ARN of the authorizer Lambda function (for granting api-gateway invoke permissions)."
  value       = module.lambda_authorizer.arn
}

output "rest_api_id" {
  description = "ID of the REST API (used for granting WAF association and lambda permissions in the consumer)."
  value       = module.api.rest_api_id
}

output "rest_api_execution_arn" {
  description = "Execution ARN prefix used for granting `lambda:InvokeFunction` permissions to API Gateway."
  value       = module.api.rest_api_execution_arn
}

output "stage_name" {
  description = "Name of the deployment stage."
  value       = module.api.stage_name
}

output "stage_arn" {
  description = "ARN of the deployment stage (used by the consumer to attach `aws_wafv2_web_acl_association`)."
  value       = module.api.stage_arn
}

output "web_acl_arn" {
  description = "ARN of the WAF Web ACL fronting the API."
  value       = module.waf.web_acl_arn
}

output "web_acl_id" {
  description = "ID of the WAF Web ACL."
  value       = module.waf.web_acl_id
}

output "custom_domain_regional_domain_name" {
  description = "Regional domain name created for the custom domain, or null when custom_domain_name is not set."
  value       = module.api.custom_domain_regional_domain_name
}

output "custom_domain_regional_zone_id" {
  description = "Regional zone ID for the custom domain, or null when not set."
  value       = module.api.custom_domain_regional_zone_id
}

output "custom_domain_record_fqdn" {
  description = "FQDN of the alias record routing the custom domain at the API, or null when not configured."
  value       = local.custom_domain_record_count == 0 ? null : module.custom_domain_record[0].fqdn
}
