# AWS VPC Terraform Module

A comprehensive Terraform module for creating and managing AWS Virtual Private Clouds (VPCs) with advanced configuration options.

## Features

- **Complete VPC Management**: Create VPCs with full configuration control
- **IPv4 and IPv6 Support**: Support for both IPv4 and IPv6 CIDR blocks
- **IPAM Integration**: Support for AWS IP Address Manager (IPAM) pools
- **DNS Configuration**: Configurable DNS support and hostname resolution
- **VPC Flow Logs**: Optional VPC Flow Logs for network monitoring
- **Network Metrics**: Optional network address usage metrics
- **Comprehensive Tagging**: Automatic and custom tag management
- **Lifecycle Management**: Proper resource lifecycle management

## Usage

### Basic Usage

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

### Advanced Usage

```hcl
module "vpc" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/vpc?ref=providers/aws/primitives/vpc/v1.0.0"

  name                                 = "advanced-vpc"
  cidr_block                           = "10.1.0.0/16"
  instance_tenancy                     = "default"
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  enable_network_address_usage_metrics = true
  assign_generated_ipv6_cidr_block     = true
  
  # VPC Flow Logs (optional)
  enable_flow_logs              = true
  flow_logs_iam_role_arn       = aws_iam_role.flow_logs.arn
  flow_logs_destination_arn    = aws_cloudwatch_log_group.vpc_flow_logs.arn
  flow_logs_traffic_type       = "ALL"
  
  tags = {
    Environment = "production"
    Project     = "my-project"
    Owner       = "platform-team"
  }
}
```

### IPAM Usage

**Note**: AWS only supports 1 instance of IPAM per AWS account and IPAM is not enabled by default in this module.

```hcl
module "vpc" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/vpc?ref=providers/aws/primitives/vpc/v1.0.0"

  name                    = "ipam-vpc"
  enable_ipam             = true
  ipv4_ipam_pool_id      = aws_vpc_ipam_pool.main.id
  ipv4_netmask_length    = 24
  
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Examples

- [Basic VPC](examples/basic/) - Simple VPC with minimal configuration
- [Advanced IPAM](examples/advanced-ipam/) - VPC with optional IPAM support (disabled by default)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.12.1 |
| aws | >= 5.14 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.14 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_flow_log.vpc_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name for the VPC and associated resources | `string` | n/a | yes |
| cidr_block | The IPv4 CIDR block for the VPC | `string` | `null` | no |
| enable_ipam | Whether to enable IPAM for this VPC. Note: AWS only supports 1 instance of IPAM per AWS account | `bool` | `false` | no |
| instance_tenancy | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| ipv4_ipam_pool_id | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR | `string` | `null` | no |
| ipv4_netmask_length | The netmask length of the IPv4 CIDR you want to allocate to this VPC | `number` | `null` | no |
| ipv6_cidr_block | IPv6 CIDR block to request from an IPAM Pool | `string` | `null` | no |
| ipv6_ipam_pool_id | IPAM Pool ID for a IPv6 pool | `string` | `null` | no |
| ipv6_netmask_length | Netmask length to request from IPAM Pool | `number` | `null` | no |
| ipv6_cidr_block_network_border_group | Network Border Group for IPv6 CIDR | `string` | `null` | no |
| enable_dns_support | A boolean flag to enable/disable DNS support in the VPC | `bool` | `true` | no |
| enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC | `bool` | `false` | no |
| enable_network_address_usage_metrics | Indicates whether Network Address Usage metrics are enabled for your VPC | `bool` | `false` | no |
| assign_generated_ipv6_cidr_block | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC | `bool` | `false` | no |
| enable_flow_logs | Whether to enable VPC Flow Logs | `bool` | `false` | no |
| flow_logs_iam_role_arn | The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group | `string` | `null` | no |
| flow_logs_destination_arn | The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed | `string` | `null` | no |
| flow_logs_traffic_type | The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL | `string` | `"ALL"` | no |
| tags | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_arn | The ARN of the VPC |
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_ipv6_cidr_block | The IPv6 CIDR block of the VPC |
| vpc_instance_tenancy | Tenancy of instances spin up within VPC |
| vpc_enable_dns_support | Whether or not the VPC has DNS support |
| vpc_enable_dns_hostnames | Whether or not the VPC has DNS hostname support |
| vpc_main_route_table_id | The ID of the main route table associated with this VPC |
| vpc_default_network_acl_id | The ID of the network ACL created by default on VPC creation |
| vpc_default_security_group_id | The ID of the security group created by default on VPC creation |
| vpc_default_route_table_id | The ID of the route table created by default on VPC creation |
| vpc_owner_id | The ID of the AWS account that owns the VPC |
| vpc_tags_all | A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block |
| flow_log_id | The Flow Log ID |
| flow_log_arn | The ARN of the Flow Log |

## Testing

This module includes comprehensive tests using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

### Running Tests

```bash
# Install dependencies
make install

# Run all tests
make test

# Run specific test suites
make test-common    # Common tests
go test -v ./tests/basic/...     # Basic example tests
go test -v ./tests/advanced/...  # Advanced example tests

# Lint and format
make go-lint
make go-format

# Clean up
make clean
```

### Test Structure

- **Common Tests**: Validation, formatting, and basic functionality tests
- **Basic Tests**: Tests for the basic example configuration
- **Advanced Tests**: Tests for advanced configuration options
- **Helper Functions**: Reusable test utilities and assertions

## Security Considerations

- **VPC Flow Logs**: Enable flow logs for network monitoring and security analysis
- **DNS Configuration**: Properly configure DNS settings based on your security requirements
- **Network Segmentation**: Use appropriate CIDR blocks for network segmentation
- **Tagging**: Implement comprehensive tagging for resource management and cost allocation

## Best Practices

1. **CIDR Planning**: Plan your CIDR blocks carefully to avoid conflicts
2. **DNS Configuration**: Enable DNS hostnames if you need them for your applications
3. **Flow Logs**: Enable VPC Flow Logs for monitoring and troubleshooting
4. **Tagging**: Use consistent tagging strategies across all resources
5. **IPAM Integration**: Consider using AWS IPAM for centralized IP address management. Note that AWS only supports 1 instance of IPAM per AWS account, so coordinate usage across your organization

## Contributing

Please see the [Contributing Guide](../../../../../../docs/CONTRIBUTING.md) for information on how to contribute to this module.

## License

This module is licensed under the Apache License, Version 2.0. See the [LICENSE](../../../../../../LICENSE) file for details.