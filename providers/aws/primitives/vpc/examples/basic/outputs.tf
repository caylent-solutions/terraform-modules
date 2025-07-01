output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_ipv6_cidr_block" {
  description = "IPv6 CIDR block of the VPC"
  value       = module.vpc.vpc_ipv6_cidr_block
}

output "vpc_main_route_table_id" {
  description = "ID of the main route table"
  value       = module.vpc.vpc_main_route_table_id
}

output "vpc_default_security_group_id" {
  description = "ID of the default security group"
  value       = module.vpc.vpc_default_security_group_id
}

output "vpc_enable_dns_support" {
  description = "Whether DNS support is enabled"
  value       = module.vpc.vpc_enable_dns_support
}

output "vpc_enable_dns_hostnames" {
  description = "Whether DNS hostnames are enabled"
  value       = module.vpc.vpc_enable_dns_hostnames
}

output "vpc_instance_tenancy" {
  description = "Instance tenancy of the VPC"
  value       = module.vpc.vpc_instance_tenancy
}

output "flow_logs_log_group_arn" {
  description = "ARN of the CloudWatch log group for VPC flow logs"
  value       = var.enable_flow_logs ? aws_cloudwatch_log_group.vpc_flow_logs[0].arn : null
}

output "flow_logs_iam_role_arn" {
  description = "ARN of the IAM role for VPC flow logs"
  value       = var.enable_flow_logs ? aws_iam_role.vpc_flow_logs[0].arn : null
}