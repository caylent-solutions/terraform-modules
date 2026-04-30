variable "domain_name" {
  description = "Name of the OpenSearch domain. Must be 3-28 characters, lowercase alphanumerics and hyphens, starting with a letter."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,27}$", var.domain_name))
    error_message = "domain_name must be 3-28 lowercase characters, alphanumerics and hyphens, starting with a letter."
  }
}

variable "engine_version" {
  description = "OpenSearch engine version (e.g. `OpenSearch_2.13`)."
  type        = string
  default     = "OpenSearch_2.13"
}

variable "instance_type" {
  description = "Instance type for data nodes (e.g. `t3.small.search`, `r6g.large.search`)."
  type        = string
  default     = "t3.small.search"
}

variable "instance_count" {
  description = "Number of data node instances."
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1
    error_message = "instance_count must be >= 1."
  }
}

variable "dedicated_master_enabled" {
  description = "Whether to provision dedicated master nodes."
  type        = bool
  default     = false
}

variable "dedicated_master_type" {
  description = "Instance type for dedicated master nodes (only used when dedicated_master_enabled = true)."
  type        = string
  default     = "t3.small.search"
}

variable "dedicated_master_count" {
  description = "Count of dedicated master nodes (3 or 5; only used when dedicated_master_enabled = true). Validation is conditional on dedicated_master_enabled."
  type        = number
  default     = 3

  validation {
    condition     = !var.dedicated_master_enabled || contains([3, 5], var.dedicated_master_count)
    error_message = "When dedicated_master_enabled = true, dedicated_master_count must be 3 or 5."
  }
}

variable "zone_awareness_enabled" {
  description = "Spread data nodes across multiple AZs."
  type        = bool
  default     = false
}

variable "availability_zone_count" {
  description = "Number of AZs (2 or 3) when zone_awareness_enabled = true. Validation is conditional on zone_awareness_enabled."
  type        = number
  default     = 2

  validation {
    condition     = !var.zone_awareness_enabled || contains([2, 3], var.availability_zone_count)
    error_message = "When zone_awareness_enabled = true, availability_zone_count must be 2 or 3."
  }
}

variable "ebs_volume_type" {
  description = "EBS volume type for data nodes. One of gp3, gp2, or io1. gp3 supports configurable iops + throughput; io1 requires iops; gp2 ignores iops/throughput."
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp3", "gp2", "io1"], var.ebs_volume_type)
    error_message = "ebs_volume_type must be gp3, gp2, or io1."
  }
}

variable "ebs_volume_size" {
  description = "EBS volume size per data node in GB."
  type        = number
  default     = 10

  validation {
    condition     = var.ebs_volume_size >= 10
    error_message = "ebs_volume_size must be >= 10 GB."
  }
}

variable "ebs_iops" {
  description = "Provisioned IOPS for the EBS volume (gp3/io1 only). io1 REQUIRES this; gp3 accepts it as an override of the default 3000; gp2 must leave this null."
  type        = number
  default     = null

  validation {
    condition     = !(var.ebs_volume_type == "gp2") || var.ebs_iops == null
    error_message = "ebs_iops is not configurable for gp2 volumes; leave null."
  }

  validation {
    condition     = !(var.ebs_volume_type == "io1") || var.ebs_iops != null
    error_message = "ebs_iops is required when ebs_volume_type = io1."
  }
}

variable "ebs_throughput" {
  description = "Provisioned throughput in MiB/s. gp3 only; null for gp2 / io1."
  type        = number
  default     = null

  validation {
    condition     = var.ebs_volume_type == "gp3" || var.ebs_throughput == null
    error_message = "ebs_throughput is only configurable for gp3 volumes; leave null for gp2 / io1."
  }
}

variable "kms_key_id" {
  description = "KMS key id, alias, or ARN for encryption at rest. When null, the AWS-managed key `aws/es` is used."
  type        = string
  default     = null
}

variable "tls_security_policy" {
  description = "TLS security policy for the domain endpoint."
  type        = string
  default     = "Policy-Min-TLS-1-2-PFS-2023-10"

  validation {
    condition = contains([
      "Policy-Min-TLS-1-0-2019-07",
      "Policy-Min-TLS-1-2-2019-07",
      "Policy-Min-TLS-1-2-PFS-2023-10",
    ], var.tls_security_policy)
    error_message = "tls_security_policy must be one of the AWS-supported values."
  }
}

variable "custom_endpoint_enabled" {
  description = "Whether to use a custom endpoint (vanity hostname) for the domain."
  type        = bool
  default     = false
}

variable "custom_endpoint" {
  description = "Custom endpoint hostname. Required when custom_endpoint_enabled = true."
  type        = string
  default     = null

  validation {
    condition     = !var.custom_endpoint_enabled || (var.custom_endpoint != null && length(var.custom_endpoint) > 0)
    error_message = "When custom_endpoint_enabled = true, custom_endpoint is required."
  }
}

variable "custom_endpoint_certificate_arn" {
  description = "ACM certificate ARN for the custom endpoint. Required when custom_endpoint_enabled = true."
  type        = string
  default     = null

  validation {
    condition     = !var.custom_endpoint_enabled || (var.custom_endpoint_certificate_arn != null && length(var.custom_endpoint_certificate_arn) > 0)
    error_message = "When custom_endpoint_enabled = true, custom_endpoint_certificate_arn is required."
  }
}

variable "vpc_subnet_ids" {
  description = "List of VPC subnet ids for VPC-mode domains. Null disables VPC mode (public domain). VPC mode requires the subnets to span the configured AZ count and the domain must be deleted/recreated to switch modes."
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group ids for the VPC-mode domain ENIs."
  type        = list(string)
  default     = []
}

variable "advanced_security_master_user_arn" {
  description = "IAM ARN to use as the master user when fine-grained access control is enabled (`advanced_security_options`). Null disables fine-grained access control."
  type        = string
  default     = null
}

variable "access_policies_json" {
  description = "Domain access policy as a JSON-encoded string. REQUIRED. Public-mode domains without an explicit access policy default to wide-open access; this primitive rejects that footgun by requiring callers to provide a deliberate policy. For VPC-mode domains where IAM controls are layered with security groups, pass a deny-all-from-other-principals policy explicitly to make the intent visible."
  type        = string
}

variable "log_retention_in_days" {
  description = "Retention for the auto-created application log group."
  type        = number
  default     = 30

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_in_days)
    error_message = "log_retention_in_days must be one of the values supported by CloudWatch Logs."
  }
}

variable "log_kms_key_arn" {
  description = "KMS key ARN to encrypt the application log group. Null uses AWS-managed encryption."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the domain, log group, and log resource policy."
  type        = map(string)
  default     = {}
}
