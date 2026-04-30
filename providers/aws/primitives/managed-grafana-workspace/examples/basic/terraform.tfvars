workspace_name      = "test-grafana-basic"
account_access_type = "CURRENT_ACCOUNT"
auth_providers      = ["AWS_SSO"]
permission_type     = "SERVICE_MANAGED"
data_sources        = ["AMAZON_OPENSEARCH_SERVICE", "CLOUDWATCH", "XRAY"]

notification_destinations = []
admin_sso_group_ids       = []
viewer_sso_group_ids      = []

tags = {
  Environment = "test"
  ManagedBy   = "terraform"
}
