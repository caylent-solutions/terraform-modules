variable "opensearch_domain_name" {
  description = "Base name for the OpenSearch domain; the example appends a random suffix."
  type        = string
  default     = "test-tobs"
}

variable "opensearch_engine_version" {
  description = "OpenSearch engine version."
  type        = string
  default     = "OpenSearch_2.13"
}

variable "opensearch_instance_type" {
  description = "OpenSearch instance type."
  type        = string
  default     = "t3.small.search"
}

variable "grafana_workspace_name" {
  description = "Base name for the Grafana workspace; the example appends a random suffix."
  type        = string
  default     = "test-telemetry-grafana"
}

variable "grafana_authentication_providers" {
  description = "Identity providers used for Grafana login. SAML default avoids the AWS Identity Center prerequisite at workspace creation time."
  type        = list(string)
  default     = ["SAML"]
}

variable "grafana_data_sources" {
  description = "AWS data sources the Grafana workspace integrates with."
  type        = list(string)
  default     = ["CLOUDWATCH"]
}

variable "indexer_function_name" {
  description = "Base name for the indexer Lambda; the example appends a random suffix."
  type        = string
  default     = "test-telemetry-indexer"
}

variable "tags" {
  description = "Tags applied to module-managed resources."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Module    = "telemetry-observability"
    Example   = "basic"
  }
}
