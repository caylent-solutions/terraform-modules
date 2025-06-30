output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.vpc.arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = aws_vpc.vpc.ipv6_cidr_block
}

output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = aws_vpc.vpc.instance_tenancy
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = aws_vpc.vpc.enable_dns_support
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = aws_vpc.vpc.enable_dns_hostnames
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = aws_vpc.vpc.main_route_table_id
}

output "vpc_default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = aws_vpc.vpc.default_network_acl_id
}

output "vpc_default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.vpc.default_security_group_id
}

output "vpc_default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = aws_vpc.vpc.default_route_table_id
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = aws_vpc.vpc.owner_id
}

output "vpc_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_vpc.vpc.tags_all
}

output "flow_log_id" {
  description = "The Flow Log ID"
  value       = var.enable_flow_logs ? aws_flow_log.vpc_flow_log[0].id : null
}

output "flow_log_arn" {
  description = "The ARN of the Flow Log"
  value       = var.enable_flow_logs ? aws_flow_log.vpc_flow_log[0].arn : null
}