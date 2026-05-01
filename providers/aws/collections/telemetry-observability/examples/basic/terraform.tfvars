opensearch_domain_name           = "test-tobs"
opensearch_engine_version        = "OpenSearch_2.13"
opensearch_instance_type         = "t3.small.search"
grafana_workspace_name           = "test-telemetry-grafana"
grafana_authentication_providers = ["SAML"]
grafana_data_sources             = ["CLOUDWATCH"]
indexer_function_name            = "test-telemetry-indexer"

tags = {
  ManagedBy = "terraform"
  Module    = "telemetry-observability"
  Example   = "basic"
}
