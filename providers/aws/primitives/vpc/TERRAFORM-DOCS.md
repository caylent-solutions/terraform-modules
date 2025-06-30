## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_flow_log.vpc_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | (Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false. Conflicts with ipv6\_ipam\_pool\_id | `bool` | `false` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | (Optional) The IPv4 CIDR block for the VPC. | `string` | `null` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | (Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false. | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | (Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults to true. | `bool` | `true` | no |
| <a name="input_enable_flow_logs"></a> [enable\_flow\_logs](#input\_enable\_flow\_logs) | (Optional) Whether to enable VPC Flow Logs. | `bool` | `true` | no |
| <a name="input_enable_ipam"></a> [enable\_ipam](#input\_enable\_ipam) | (Optional) Whether to enable IPAM for this VPC. Note: AWS only supports 1 instance of IPAM per AWS account. | `bool` | `false` | no |
| <a name="input_enable_network_address_usage_metrics"></a> [enable\_network\_address\_usage\_metrics](#input\_enable\_network\_address\_usage\_metrics) | (Optional) Indicates whether Network Address Usage metrics are enabled for your VPC. Defaults to false. | `bool` | `false` | no |
| <a name="input_flow_logs_destination_arn"></a> [flow\_logs\_destination\_arn](#input\_flow\_logs\_destination\_arn) | (Optional) The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. Required if enable\_flow\_logs is true. | `string` | `null` | no |
| <a name="input_flow_logs_iam_role_arn"></a> [flow\_logs\_iam\_role\_arn](#input\_flow\_logs\_iam\_role\_arn) | (Optional) The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. Required if enable\_flow\_logs is true. | `string` | `null` | no |
| <a name="input_flow_logs_name_suffix"></a> [flow\_logs\_name\_suffix](#input\_flow\_logs\_name\_suffix) | (Optional) Suffix for flow logs name. | `string` | `"flow-logs"` | no |
| <a name="input_flow_logs_traffic_type"></a> [flow\_logs\_traffic\_type](#input\_flow\_logs\_traffic\_type) | (Optional) The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL. | `string` | `"ALL"` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | (Optional) A tenancy option for instances launched into the VPC. | `string` | `"default"` | no |
| <a name="input_ipv4_ipam_pool_id"></a> [ipv4\_ipam\_pool\_id](#input\_ipv4\_ipam\_pool\_id) | (Optional) The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | `string` | `null` | no |
| <a name="input_ipv4_netmask_length"></a> [ipv4\_netmask\_length](#input\_ipv4\_netmask\_length) | (Optional) The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv4\_ipam\_pool\_id. | `number` | `null` | no |
| <a name="input_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#input\_ipv6\_cidr\_block) | (Optional) IPv6 CIDR block to request from an IPAM Pool. Can be set explicitly or derived from IPAM using ipv6\_netmask\_length. | `string` | `null` | no |
| <a name="input_ipv6_cidr_block_network_border_group"></a> [ipv6\_cidr\_block\_network\_border\_group](#input\_ipv6\_cidr\_block\_network\_border\_group) | (Optional) By default when an IPv6 CIDR is assigned to a VPC a default ipv6\_cidr\_block\_network\_border\_group will be set to the region of the VPC. This can be changed to restrict advertisement of public addresses to specific Network Border Groups such as LocalZones. | `string` | `null` | no |
| <a name="input_ipv6_ipam_pool_id"></a> [ipv6\_ipam\_pool\_id](#input\_ipv6\_ipam\_pool\_id) | (Optional) IPAM Pool ID for a IPv6 pool. Conflicts with assign\_generated\_ipv6\_cidr\_block. | `string` | `null` | no |
| <a name="input_ipv6_netmask_length"></a> [ipv6\_netmask\_length](#input\_ipv6\_netmask\_length) | (Optional) Netmask length to request from IPAM Pool. Conflicts with ipv6\_cidr\_block. This can be omitted if IPAM pool as a allocation\_default\_netmask\_length set. Valid values are from 44 to 60 in increments of 4. | `number` | `null` | no |
| <a name="input_managed_by_tag"></a> [managed\_by\_tag](#input\_managed\_by\_tag) | (Optional) Value for the ManagedBy tag. | `string` | `"terraform"` | no |
| <a name="input_module_tag"></a> [module\_tag](#input\_module\_tag) | (Optional) Value for the Module tag. | `string` | `"vpc"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name for the VPC and associated resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_flow_log_arn"></a> [flow\_log\_arn](#output\_flow\_log\_arn) | The ARN of the Flow Log |
| <a name="output_flow_log_id"></a> [flow\_log\_id](#output\_flow\_log\_id) | The Flow Log ID |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_default_network_acl_id"></a> [vpc\_default\_network\_acl\_id](#output\_vpc\_default\_network\_acl\_id) | The ID of the network ACL created by default on VPC creation |
| <a name="output_vpc_default_route_table_id"></a> [vpc\_default\_route\_table\_id](#output\_vpc\_default\_route\_table\_id) | The ID of the route table created by default on VPC creation |
| <a name="output_vpc_default_security_group_id"></a> [vpc\_default\_security\_group\_id](#output\_vpc\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#output\_vpc\_enable\_dns\_hostnames) | Whether or not the VPC has DNS hostname support |
| <a name="output_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#output\_vpc\_enable\_dns\_support) | Whether or not the VPC has DNS support |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_instance_tenancy"></a> [vpc\_instance\_tenancy](#output\_vpc\_instance\_tenancy) | Tenancy of instances spin up within VPC |
| <a name="output_vpc_ipv6_cidr_block"></a> [vpc\_ipv6\_cidr\_block](#output\_vpc\_ipv6\_cidr\_block) | The IPv6 CIDR block of the VPC |
| <a name="output_vpc_main_route_table_id"></a> [vpc\_main\_route\_table\_id](#output\_vpc\_main\_route\_table\_id) | The ID of the main route table associated with this VPC |
| <a name="output_vpc_owner_id"></a> [vpc\_owner\_id](#output\_vpc\_owner\_id) | The ID of the AWS account that owns the VPC |
| <a name="output_vpc_tags_all"></a> [vpc\_tags\_all](#output\_vpc\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block |
