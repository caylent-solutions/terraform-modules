workspace_name            = "test-grafana"
authentication_providers  = ["SAML"]
account_access_type       = "CURRENT_ACCOUNT"
permission_type           = "SERVICE_MANAGED"
data_sources              = ["CLOUDWATCH"]
notification_destinations = ["SNS"]

tags = {
  ManagedBy = "terraform"
  Module    = "managed-grafana-workspace"
  Example   = "basic"
}
