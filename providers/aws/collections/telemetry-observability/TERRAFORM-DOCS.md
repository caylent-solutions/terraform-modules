## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_grafana"></a> [grafana](#module\_grafana) | git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/managed-grafana-workspace | providers/aws/primitives/managed-grafana-workspace/v0.1.0 |
| <a name="module_indexer"></a> [indexer](#module\_indexer) | git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/lambda | providers/aws/primitives/lambda/v0.1.0 |
| <a name="module_opensearch"></a> [opensearch](#module\_opensearch) | git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/opensearch-domain | providers/aws/primitives/opensearch-domain/v0.1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarms_topic_arn"></a> [alarms\_topic\_arn](#input\_alarms\_topic\_arn) | Externally provisioned SNS topic ARN for CloudWatch alarms (e.g. PagerDuty / Slack forwarder). The collection passes this through unchanged on the alarms\_topic\_arn output; consumers wire CloudWatch alarm subscriptions in their own root module. | `string` | `null` | no |
| <a name="input_grafana_account_access_type"></a> [grafana\_account\_access\_type](#input\_grafana\_account\_access\_type) | How the workspace accesses AWS data sources. | `string` | `"CURRENT_ACCOUNT"` | no |
| <a name="input_grafana_admin_sso_group_ids"></a> [grafana\_admin\_sso\_group\_ids](#input\_grafana\_admin\_sso\_group\_ids) | AWS SSO group ids granted ADMIN role on the workspace. | `list(string)` | `[]` | no |
| <a name="input_grafana_authentication_providers"></a> [grafana\_authentication\_providers](#input\_grafana\_authentication\_providers) | Identity providers used for workspace login. | `list(string)` | <pre>[<br/>  "AWS_SSO"<br/>]</pre> | no |
| <a name="input_grafana_data_sources"></a> [grafana\_data\_sources](#input\_grafana\_data\_sources) | AWS data sources the workspace integrates with. | `list(string)` | <pre>[<br/>  "AMAZON_OPENSEARCH_SERVICE",<br/>  "CLOUDWATCH",<br/>  "XRAY"<br/>]</pre> | no |
| <a name="input_grafana_description"></a> [grafana\_description](#input\_grafana\_description) | Description of the workspace. | `string` | `null` | no |
| <a name="input_grafana_editor_sso_group_ids"></a> [grafana\_editor\_sso\_group\_ids](#input\_grafana\_editor\_sso\_group\_ids) | AWS SSO group ids granted EDITOR role on the workspace. | `list(string)` | `[]` | no |
| <a name="input_grafana_notification_destinations"></a> [grafana\_notification\_destinations](#input\_grafana\_notification\_destinations) | Notification destination types the workspace can publish to. | `list(string)` | <pre>[<br/>  "SNS"<br/>]</pre> | no |
| <a name="input_grafana_permission_type"></a> [grafana\_permission\_type](#input\_grafana\_permission\_type) | Workspace permission type. | `string` | `"SERVICE_MANAGED"` | no |
| <a name="input_grafana_viewer_sso_group_ids"></a> [grafana\_viewer\_sso\_group\_ids](#input\_grafana\_viewer\_sso\_group\_ids) | AWS SSO group ids granted VIEWER role on the workspace. | `list(string)` | `[]` | no |
| <a name="input_grafana_vpc_configuration"></a> [grafana\_vpc\_configuration](#input\_grafana\_vpc\_configuration) | Optional VPC configuration `{ subnet_ids, security_group_ids }`. Null disables VPC mode. | <pre>object({<br/>    subnet_ids         = list(string)<br/>    security_group_ids = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_grafana_workspace_name"></a> [grafana\_workspace\_name](#input\_grafana\_workspace\_name) | Name of the Managed Grafana workspace. | `string` | n/a | yes |
| <a name="input_indexer_description"></a> [indexer\_description](#input\_indexer\_description) | Description of the indexer Lambda. | `string` | `"OpenSearch indexer for the telemetry observability stack"` | no |
| <a name="input_indexer_environment"></a> [indexer\_environment](#input\_indexer\_environment) | Plain (non-secret) environment variables for the indexer Lambda. | `map(string)` | `{}` | no |
| <a name="input_indexer_filename"></a> [indexer\_filename](#input\_indexer\_filename) | Local Zip artifact path. | `string` | `null` | no |
| <a name="input_indexer_function_name"></a> [indexer\_function\_name](#input\_indexer\_function\_name) | Name of the OpenSearch indexer Lambda. | `string` | n/a | yes |
| <a name="input_indexer_handler"></a> [indexer\_handler](#input\_indexer\_handler) | Indexer handler entrypoint (Zip package only). | `string` | `null` | no |
| <a name="input_indexer_image_uri"></a> [indexer\_image\_uri](#input\_indexer\_image\_uri) | ECR image URI when package\_type = Image. | `string` | `null` | no |
| <a name="input_indexer_memory_size"></a> [indexer\_memory\_size](#input\_indexer\_memory\_size) | Indexer Lambda memory size in MB. | `number` | `512` | no |
| <a name="input_indexer_package_type"></a> [indexer\_package\_type](#input\_indexer\_package\_type) | Lambda packaging type. Zip or Image. | `string` | `"Zip"` | no |
| <a name="input_indexer_role_arn"></a> [indexer\_role\_arn](#input\_indexer\_role\_arn) | IAM role ARN the indexer Lambda assumes. | `string` | n/a | yes |
| <a name="input_indexer_runtime"></a> [indexer\_runtime](#input\_indexer\_runtime) | Indexer Lambda runtime (Zip package only). | `string` | `null` | no |
| <a name="input_indexer_s3_bucket"></a> [indexer\_s3\_bucket](#input\_indexer\_s3\_bucket) | S3 bucket holding the indexer Zip artifact. | `string` | `null` | no |
| <a name="input_indexer_s3_key"></a> [indexer\_s3\_key](#input\_indexer\_s3\_key) | S3 key for the indexer Zip artifact. | `string` | `null` | no |
| <a name="input_indexer_timeout"></a> [indexer\_timeout](#input\_indexer\_timeout) | Indexer Lambda execution timeout in seconds. | `number` | `30` | no |
| <a name="input_opensearch_access_policies_json"></a> [opensearch\_access\_policies\_json](#input\_opensearch\_access\_policies\_json) | Domain access policy as a JSON-encoded string. The opensearch-domain primitive intentionally has no default (rejects the open-public-access footgun); the collection passes the value through verbatim. Set to null to defer to AWS default access (acceptable in dev, NOT in production). | `string` | n/a | yes |
| <a name="input_opensearch_availability_zone_count"></a> [opensearch\_availability\_zone\_count](#input\_opensearch\_availability\_zone\_count) | Number of AZs to spread the cluster across when zone awareness is enabled (2 or 3). Default matches the opensearch-domain primitive default. | `number` | `2` | no |
| <a name="input_opensearch_dedicated_master_count"></a> [opensearch\_dedicated\_master\_count](#input\_opensearch\_dedicated\_master\_count) | Count of dedicated master nodes (3 or 5; only used when dedicated\_master\_enabled = true). Default matches the opensearch-domain primitive default. | `number` | `3` | no |
| <a name="input_opensearch_dedicated_master_enabled"></a> [opensearch\_dedicated\_master\_enabled](#input\_opensearch\_dedicated\_master\_enabled) | Whether dedicated master nodes are enabled. | `bool` | `false` | no |
| <a name="input_opensearch_dedicated_master_type"></a> [opensearch\_dedicated\_master\_type](#input\_opensearch\_dedicated\_master\_type) | Instance type for dedicated master nodes (only used when dedicated\_master\_enabled = true). Default matches the opensearch-domain primitive default. | `string` | `"t3.small.search"` | no |
| <a name="input_opensearch_domain_name"></a> [opensearch\_domain\_name](#input\_opensearch\_domain\_name) | Name of the OpenSearch domain. | `string` | n/a | yes |
| <a name="input_opensearch_ebs_volume_size"></a> [opensearch\_ebs\_volume\_size](#input\_opensearch\_ebs\_volume\_size) | EBS volume size in GiB. | `number` | `10` | no |
| <a name="input_opensearch_ebs_volume_type"></a> [opensearch\_ebs\_volume\_type](#input\_opensearch\_ebs\_volume\_type) | EBS volume type. | `string` | `"gp3"` | no |
| <a name="input_opensearch_engine_version"></a> [opensearch\_engine\_version](#input\_opensearch\_engine\_version) | OpenSearch engine version (e.g. OpenSearch\_2.13). | `string` | `"OpenSearch_2.13"` | no |
| <a name="input_opensearch_instance_count"></a> [opensearch\_instance\_count](#input\_opensearch\_instance\_count) | Number of data nodes. | `number` | `1` | no |
| <a name="input_opensearch_instance_type"></a> [opensearch\_instance\_type](#input\_opensearch\_instance\_type) | Instance type for OpenSearch data nodes. | `string` | `"t3.small.search"` | no |
| <a name="input_opensearch_kms_key_id"></a> [opensearch\_kms\_key\_id](#input\_opensearch\_kms\_key\_id) | KMS CMK identifier for at-rest encryption. Null falls back to the AWS-managed key. | `string` | `null` | no |
| <a name="input_opensearch_log_kms_key_arn"></a> [opensearch\_log\_kms\_key\_arn](#input\_opensearch\_log\_kms\_key\_arn) | KMS CMK ARN used to encrypt the auto-managed log groups at rest. | `string` | `null` | no |
| <a name="input_opensearch_log_retention_in_days"></a> [opensearch\_log\_retention\_in\_days](#input\_opensearch\_log\_retention\_in\_days) | Retention (days) for the auto-managed CloudWatch log groups attached to the domain. | `number` | `30` | no |
| <a name="input_opensearch_tls_security_policy"></a> [opensearch\_tls\_security\_policy](#input\_opensearch\_tls\_security\_policy) | TLS security policy for the domain endpoint. Default matches the opensearch-domain primitive default (perfect-forward-secrecy enforced). | `string` | `"Policy-Min-TLS-1-2-PFS-2023-10"` | no |
| <a name="input_opensearch_vpc_security_group_ids"></a> [opensearch\_vpc\_security\_group\_ids](#input\_opensearch\_vpc\_security\_group\_ids) | Security groups for VPC-mode deployment. Default matches the opensearch-domain primitive default (empty list). | `list(string)` | `[]` | no |
| <a name="input_opensearch_vpc_subnet_ids"></a> [opensearch\_vpc\_subnet\_ids](#input\_opensearch\_vpc\_subnet\_ids) | VPC subnet IDs for VPC-mode deployment. Null deploys the domain to public AWS-managed network. | `list(string)` | `null` | no |
| <a name="input_opensearch_zone_awareness_enabled"></a> [opensearch\_zone\_awareness\_enabled](#input\_opensearch\_zone\_awareness\_enabled) | Whether multi-AZ zone awareness is enabled. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all module-managed resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarms_topic_arn"></a> [alarms\_topic\_arn](#output\_alarms\_topic\_arn) | Pass-through of the consumer-supplied SNS topic ARN that downstream CloudWatch alarms publish to. Null when not configured. |
| <a name="output_grafana_workspace_arn"></a> [grafana\_workspace\_arn](#output\_grafana\_workspace\_arn) | ARN of the Managed Grafana workspace. |
| <a name="output_grafana_workspace_id"></a> [grafana\_workspace\_id](#output\_grafana\_workspace\_id) | Identifier of the Managed Grafana workspace. |
| <a name="output_grafana_workspace_url"></a> [grafana\_workspace\_url](#output\_grafana\_workspace\_url) | Endpoint URL of the Managed Grafana workspace. |
| <a name="output_indexer_function_arn"></a> [indexer\_function\_arn](#output\_indexer\_function\_arn) | ARN of the OpenSearch indexer Lambda. |
| <a name="output_indexer_function_name"></a> [indexer\_function\_name](#output\_indexer\_function\_name) | Name of the OpenSearch indexer Lambda. |
| <a name="output_indexer_invoke_arn"></a> [indexer\_invoke\_arn](#output\_indexer\_invoke\_arn) | Invoke ARN of the OpenSearch indexer Lambda (for event source mappings). |
| <a name="output_opensearch_domain_arn"></a> [opensearch\_domain\_arn](#output\_opensearch\_domain\_arn) | ARN of the OpenSearch domain. |
| <a name="output_opensearch_domain_endpoint"></a> [opensearch\_domain\_endpoint](#output\_opensearch\_domain\_endpoint) | Endpoint URL of the OpenSearch domain. |
| <a name="output_opensearch_domain_name"></a> [opensearch\_domain\_name](#output\_opensearch\_domain\_name) | Name of the OpenSearch domain. |
