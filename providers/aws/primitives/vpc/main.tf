resource "aws_vpc" "vpc" {
  cidr_block                           = var.enable_ipam ? null : var.cidr_block
  instance_tenancy                     = var.instance_tenancy
  ipv4_ipam_pool_id                    = var.enable_ipam ? var.ipv4_ipam_pool_id : null
  ipv4_netmask_length                  = var.enable_ipam ? var.ipv4_netmask_length : null
  ipv6_cidr_block                      = var.ipv6_cidr_block
  ipv6_ipam_pool_id                    = var.enable_ipam ? var.ipv6_ipam_pool_id : null
  ipv6_netmask_length                  = var.enable_ipam ? var.ipv6_netmask_length : null
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group
  enable_dns_support                   = local.dns_support_enabled
  enable_dns_hostnames                 = local.dns_hostnames_enabled
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  assign_generated_ipv6_cidr_block     = var.assign_generated_ipv6_cidr_block
  tags                                 = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.vpc.id

  ingress = []
  egress  = []

  tags = local.common_tags
}

resource "aws_vpc_dhcp_options" "this" {
  count = var.dhcp_options != null ? 1 : 0

  domain_name_servers = (
    var.dhcp_options != null && var.dhcp_options.domain_name_servers != null
    ? var.dhcp_options.domain_name_servers
    : ["AmazonProvidedDNS"]
  )

  tags = local.common_tags
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = var.dhcp_options != null ? 1 : 0

  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}

resource "aws_flow_log" "vpc_flow_log" {
  count = var.enable_flow_logs ? 1 : 0

  iam_role_arn    = var.flow_logs_iam_role_arn
  log_destination = var.flow_logs_destination_arn
  traffic_type    = var.flow_logs_traffic_type
  vpc_id          = aws_vpc.vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name}-${var.flow_logs_name_suffix}"
    }
  )

  depends_on = [
    aws_vpc_dhcp_options_association.this
  ]
}
