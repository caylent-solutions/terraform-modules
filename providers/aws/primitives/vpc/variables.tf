variable "cidr_block" {
  type        = string
  description = "(Optional) The IPv4 CIDR block for the VPC."
  default     = null
}

variable "instance_tenancy" {
  type        = string
  description = "(Optional) A tenancy option for instances launched into the VPC."
  default     = "default"
}

variable "ipv4_ipam_pool_id" {
  type        = string
  description = "(Optional) The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR."
  default     = null
}

variable "ipv4_netmask_length" {
  type        = number
  description = "(Optional) The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv4_ipam_pool_id."
  default     = null
  validation {
    condition     = coalesce(var.ipv4_netmask_length, 1) > 0
    error_message = "ipv4_netmask_length should be greather than 0"
  }
}

variable "ipv6_cidr_block" {
  type        = string
  description = "(Optional) IPv6 CIDR block to request from an IPAM Pool. Can be set explicitly or derived from IPAM using ipv6_netmask_length."
  default     = null
}

variable "ipv6_ipam_pool_id" {
  type        = string
  description = "(Optional) IPAM Pool ID for a IPv6 pool. Conflicts with assign_generated_ipv6_cidr_block."
  default     = null
}

variable "ipv6_netmask_length" {
  type        = number
  description = "(Optional) Netmask length to request from IPAM Pool. Conflicts with ipv6_cidr_block. This can be omitted if IPAM pool as a allocation_default_netmask_length set. Valid values are from 44 to 60 in increments of 4."
  default     = null
  validation {
    condition     = coalesce(var.ipv6_netmask_length, 44) >= 44 && coalesce(var.ipv6_netmask_length, 44) <= 60 && coalesce(var.ipv6_netmask_length, 44) % 4 == 0
    error_message = "ipv6_netmask_length valid values are from 44 to 60 in increments of 4."
  }
}

variable "ipv6_cidr_block_network_border_group" {
  type        = string
  description = "(Optional) By default when an IPv6 CIDR is assigned to a VPC a default ipv6_cidr_block_network_border_group will be set to the region of the VPC. This can be changed to restrict advertisement of public addresses to specific Network Border Groups such as LocalZones."
  default     = null
}

variable "enable_dns_support" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults to true."
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  default     = false
}

variable "enable_network_address_usage_metrics" {
  type        = bool
  description = "(Optional) Indicates whether Network Address Usage metrics are enabled for your VPC. Defaults to false."
  default     = false
}

variable "assign_generated_ipv6_cidr_block" {
  type        = bool
  description = "(Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false. Conflicts with ipv6_ipam_pool_id"
  default     = false
}

variable "name" {
  type        = string
  description = "(Required) Name for the VPC and associated resources."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  default     = {}
}

variable "enable_ipam" {
  type        = bool
  description = "(Optional) Whether to enable IPAM for this VPC. Note: AWS only supports 1 instance of IPAM per AWS account."
  default     = false
}

variable "enable_flow_logs" {
  type        = bool
  description = "(Optional) Whether to enable VPC Flow Logs."
  default     = true
}

variable "flow_logs_iam_role_arn" {
  type        = string
  description = "(Optional) The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. Required if enable_flow_logs is true."
  default     = null
}

variable "flow_logs_destination_arn" {
  type        = string
  description = "(Optional) The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. Required if enable_flow_logs is true."
  default     = null
}

variable "flow_logs_traffic_type" {
  type        = string
  description = "(Optional) The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL."
  default     = "ALL"
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_logs_traffic_type)
    error_message = "flow_logs_traffic_type must be one of: ACCEPT, REJECT, ALL."
  }
}

variable "managed_by_tag" {
  type        = string
  description = "(Optional) Value for the ManagedBy tag."
  default     = "terraform"
}

variable "module_tag" {
  type        = string
  description = "(Optional) Value for the Module tag."
  default     = "vpc"
}

variable "flow_logs_name_suffix" {
  type        = string
  description = "(Optional) Suffix for flow logs name."
  default     = "flow-logs"
}
