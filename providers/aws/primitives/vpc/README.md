# AWS VPC Terraform Module

A comprehensive Terraform module for creating and managing AWS Virtual Private Clouds (VPCs) with advanced configuration options including IPAM integration, flow logs, and DHCP options.

## Overview

This module provides a complete solution for VPC management with support for both traditional CIDR-based and AWS IPAM-based IP address allocation. It includes built-in security features like VPC Flow Logs, customizable DHCP options, and proper default security group management.

## Key Features

- **Flexible IP Management**: Support for traditional CIDR blocks or AWS IPAM pools
- **IPv4 and IPv6 Support**: Full dual-stack networking capabilities
- **Security by Default**: VPC Flow Logs enabled by default with customizable traffic capture
- **DNS Configuration**: Configurable DNS support and hostname resolution
- **DHCP Options**: Custom DHCP configuration with sensible defaults
- **Default Security Group**: Managed default security group with customizable rules
- **Comprehensive Tagging**: Automatic resource tagging with custom tag support

## Quick Start

### Basic VPC

```hcl
module "vpc" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/vpc?ref=providers/aws/primitives/vpc/v1.0.0"

  name       = "my-vpc"
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### VPC with Flow Logs

```hcl
# CloudWatch Log Group for Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flowlogs/my-vpc"
  retention_in_days = 7
}

# IAM Role for Flow Logs
resource "aws_iam_role" "vpc_flow_logs" {
  name = "my-vpc-flow-logs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
    }]
  })
}

module "vpc" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/vpc?ref=providers/aws/primitives/vpc/v1.0.0"

  name                      = "my-vpc"
  cidr_block               = "10.0.0.0/16"
  enable_dns_hostnames     = true
  flow_logs_iam_role_arn   = aws_iam_role.vpc_flow_logs.arn
  flow_logs_destination_arn = aws_cloudwatch_log_group.vpc_flow_logs.arn
  
  tags = {
    Environment = "production"
  }
}
```

### IPAM-Managed VPC

```hcl
module "vpc" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/vpc?ref=providers/aws/primitives/vpc/v1.0.0"

  name                = "ipam-vpc"
  enable_ipam         = true
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.main.id
  ipv4_netmask_length = 24
  
  tags = {
    Environment = "production"
  }
}
```

## Configuration Options

### DNS Configuration

The module provides flexible DNS configuration:

- `enable_dns_support`: Controls DNS resolution (default: `true`)
- `enable_dns_hostnames`: Controls DNS hostname assignment (default: `false`)

**Note**: DNS hostnames are automatically disabled if DNS support is disabled.

### Flow Logs

VPC Flow Logs are **enabled by default** for security monitoring:

- `enable_flow_logs`: Enable/disable flow logs (default: `true`)
- `flow_logs_traffic_type`: Traffic to capture - ACCEPT, REJECT, or ALL (default: `ALL`)
- `flow_logs_iam_role_arn`: IAM role for log delivery (required when enabled)
- `flow_logs_destination_arn`: CloudWatch Log Group or S3 bucket ARN (required when enabled)

### DHCP Options

Customize DHCP options for your VPC:

```hcl
module "vpc" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/vpc?ref=providers/aws/primitives/vpc/v1.0.0"
  
  name       = "custom-dhcp-vpc"
  cidr_block = "10.0.0.0/16"
  
  dhcp_options = {
    domain_name_servers = ["8.8.8.8", "8.8.4.4"]
  }
}
```

### Default Security Group

The module manages the default security group with customizable rules:

```hcl
module "vpc" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/vpc?ref=providers/aws/primitives/vpc/v1.0.0"
  
  name       = "secure-vpc"
  cidr_block = "10.0.0.0/16"
  
  default_security_group_ingress = []
  default_security_group_egress  = []
}
```

## IPAM Integration

**Important**: AWS supports only one IPAM instance per AWS account. Coordinate IPAM usage across your organization.

When using IPAM:
- Set `enable_ipam = true`
- Provide either `ipv4_ipam_pool_id` or `ipv6_ipam_pool_id`
- Specify netmask length or use pool defaults
- Do not specify `cidr_block` when using IPAM

## Examples

See the [examples](examples/) directory for complete working examples:

- [Basic VPC](examples/basic/) - Simple VPC with flow logs and IAM setup

## Technical Documentation

For detailed technical specifications including all inputs, outputs, and resources, see [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Security Best Practices

1. **Enable Flow Logs**: Keep the default flow logs enabled for security monitoring
2. **Restrict Default Security Group**: Use empty ingress/egress rules for the default security group
3. **Plan CIDR Blocks**: Avoid overlapping CIDR blocks across VPCs
4. **Use IPAM**: Consider AWS IPAM for centralized IP address management
5. **Tag Resources**: Implement consistent tagging for security and cost management

## Contributing

See [Contributing Guide](../../../../../../docs/CONTRIBUTING.md) for development and contribution guidelines.
