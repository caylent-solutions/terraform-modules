# --- OpenSearch domain (opensearch-domain primitive) ------------------------

variable "opensearch_domain_name" {
  description = "Name of the OpenSearch domain."
  type        = string
}

variable "opensearch_engine_version" {
  description = "OpenSearch engine version (e.g. OpenSearch_2.13)."
  type        = string
  default     = "OpenSearch_2.13"
}

variable "opensearch_instance_type" {
  description = "Instance type for OpenSearch data nodes."
  type        = string
  default     = "t3.small.search"
}

variable "opensearch_instance_count" {
  description = "Number of data nodes."
  type        = number
  default     = 1
}

variable "opensearch_dedicated_master_enabled" {
  description = "Whether dedicated master nodes are enabled."
  type        = bool
  default     = false
}

variable "opensearch_dedicated_master_type" {
  description = "Instance type for dedicated master nodes (only used when dedicated_master_enabled = true). Default matches the opensearch-domain primitive default."
  type        = string
  default     = "t3.small.search"
}

variable "opensearch_dedicated_master_count" {
  description = "Count of dedicated master nodes (3 or 5; only used when dedicated_master_enabled = true). Default matches the opensearch-domain primitive default."
  type        = number
  default     = 3
}

variable "opensearch_zone_awareness_enabled" {
  description = "Whether multi-AZ zone awareness is enabled."
  type        = bool
  default     = false
}

variable "opensearch_availability_zone_count" {
  description = "Number of AZs to spread the cluster across when zone awareness is enabled (2 or 3). Default matches the opensearch-domain primitive default."
  type        = number
  default     = 2
}

variable "opensearch_ebs_volume_type" {
  description = "EBS volume type."
  type        = string
  default     = "gp3"
}

variable "opensearch_ebs_volume_size" {
  description = "EBS volume size in GiB."
  type        = number
  default     = 10
}

variable "opensearch_kms_key_id" {
  description = "KMS CMK identifier for at-rest encryption. Null falls back to the AWS-managed key."
  type        = string
  default     = null
}

variable "opensearch_tls_security_policy" {
  description = "TLS security policy for the domain endpoint. Default matches the opensearch-domain primitive default (perfect-forward-secrecy enforced)."
  type        = string
  default     = "Policy-Min-TLS-1-2-PFS-2023-10"
}

variable "opensearch_vpc_subnet_ids" {
  description = "VPC subnet IDs for VPC-mode deployment. Null deploys the domain to public AWS-managed network."
  type        = list(string)
  default     = null
}

variable "opensearch_vpc_security_group_ids" {
  description = "Security groups for VPC-mode deployment. Default matches the opensearch-domain primitive default (empty list)."
  type        = list(string)
  default     = []
}

variable "opensearch_access_policies_json" {
  description = "Domain access policy as a JSON-encoded string. The opensearch-domain primitive intentionally has no default (rejects the open-public-access footgun); the collection passes the value through verbatim. Set to null to defer to AWS default access (acceptable in dev, NOT in production)."
  type        = string
}

variable "opensearch_log_retention_in_days" {
  description = "Retention (days) for the auto-managed CloudWatch log groups attached to the domain."
  type        = number
  default     = 30
}

variable "opensearch_log_kms_key_arn" {
  description = "KMS CMK ARN used to encrypt the auto-managed log groups at rest."
  type        = string
  default     = null
}

# --- Managed Grafana workspace (managed-grafana-workspace primitive) --------

variable "grafana_workspace_name" {
  description = "Name of the Managed Grafana workspace."
  type        = string
}

variable "grafana_description" {
  description = "Description of the workspace."
  type        = string
  default     = null
}

variable "grafana_account_access_type" {
  description = "How the workspace accesses AWS data sources."
  type        = string
  default     = "CURRENT_ACCOUNT"
}

variable "grafana_authentication_providers" {
  description = "Identity providers used for workspace login."
  type        = list(string)
  default     = ["AWS_SSO"]
}

variable "grafana_permission_type" {
  description = "Workspace permission type."
  type        = string
  default     = "SERVICE_MANAGED"
}

variable "grafana_data_sources" {
  description = "AWS data sources the workspace integrates with."
  type        = list(string)
  default     = ["AMAZON_OPENSEARCH_SERVICE", "CLOUDWATCH", "XRAY"]
}

variable "grafana_notification_destinations" {
  description = "Notification destination types the workspace can publish to."
  type        = list(string)
  default     = ["SNS"]
}

variable "grafana_admin_sso_group_ids" {
  description = "AWS SSO group ids granted ADMIN role on the workspace."
  type        = list(string)
  default     = []
}

variable "grafana_editor_sso_group_ids" {
  description = "AWS SSO group ids granted EDITOR role on the workspace."
  type        = list(string)
  default     = []
}

variable "grafana_viewer_sso_group_ids" {
  description = "AWS SSO group ids granted VIEWER role on the workspace."
  type        = list(string)
  default     = []
}

variable "grafana_vpc_configuration" {
  description = "Optional VPC configuration `{ subnet_ids, security_group_ids }`. Null disables VPC mode."
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

# --- Indexer Lambda (lambda primitive) --------------------------------------

variable "indexer_function_name" {
  description = "Name of the OpenSearch indexer Lambda."
  type        = string
}

variable "indexer_description" {
  description = "Description of the indexer Lambda."
  type        = string
  default     = "OpenSearch indexer for the telemetry observability stack"
}

variable "indexer_role_arn" {
  description = "IAM role ARN the indexer Lambda assumes."
  type        = string
}

variable "indexer_package_type" {
  description = "Lambda packaging type. Zip or Image."
  type        = string
  default     = "Zip"
}

variable "indexer_filename" {
  description = "Local Zip artifact path."
  type        = string
  default     = null
}

variable "indexer_s3_bucket" {
  description = "S3 bucket holding the indexer Zip artifact."
  type        = string
  default     = null
}

variable "indexer_s3_key" {
  description = "S3 key for the indexer Zip artifact."
  type        = string
  default     = null
}

variable "indexer_image_uri" {
  description = "ECR image URI when package_type = Image."
  type        = string
  default     = null
}

variable "indexer_handler" {
  description = "Indexer handler entrypoint (Zip package only)."
  type        = string
  default     = null
}

variable "indexer_runtime" {
  description = "Indexer Lambda runtime (Zip package only)."
  type        = string
  default     = null
}

variable "indexer_memory_size" {
  description = "Indexer Lambda memory size in MB."
  type        = number
  default     = 512
}

variable "indexer_timeout" {
  description = "Indexer Lambda execution timeout in seconds."
  type        = number
  default     = 30
}

variable "indexer_environment" {
  description = "Plain (non-secret) environment variables for the indexer Lambda."
  type        = map(string)
  default     = {}
}

# --- Alarms / SNS (consumer-supplied) --------------------------------------

variable "alarms_topic_arn" {
  description = "Externally provisioned SNS topic ARN for CloudWatch alarms (e.g. PagerDuty / Slack forwarder). The collection passes this through unchanged on the alarms_topic_arn output; consumers wire CloudWatch alarm subscriptions in their own root module."
  type        = string
  default     = null
}

# --- Common -----------------------------------------------------------------

variable "tags" {
  description = "Tags applied to all module-managed resources."
  type        = map(string)
  default     = {}
}
