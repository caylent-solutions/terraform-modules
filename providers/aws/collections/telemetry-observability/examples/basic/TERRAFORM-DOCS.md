# Basic Example Documentation

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_telemetry_observability"></a> [telemetry\_observability](#module\_telemetry\_observability) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.indexer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.indexer_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.indexer](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.lambda_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_grafana_authentication_providers"></a> [grafana\_authentication\_providers](#input\_grafana\_authentication\_providers) | Identity providers used for Grafana login. SAML default avoids the AWS Identity Center prerequisite at workspace creation time. | `list(string)` | <pre>[<br/>  "SAML"<br/>]</pre> | no |
| <a name="input_grafana_data_sources"></a> [grafana\_data\_sources](#input\_grafana\_data\_sources) | AWS data sources the Grafana workspace integrates with. | `list(string)` | <pre>[<br/>  "CLOUDWATCH"<br/>]</pre> | no |
| <a name="input_grafana_workspace_name"></a> [grafana\_workspace\_name](#input\_grafana\_workspace\_name) | Base name for the Grafana workspace; the example appends a random suffix. | `string` | `"test-telemetry-grafana"` | no |
| <a name="input_indexer_function_name"></a> [indexer\_function\_name](#input\_indexer\_function\_name) | Base name for the indexer Lambda; the example appends a random suffix. | `string` | `"test-telemetry-indexer"` | no |
| <a name="input_opensearch_domain_name"></a> [opensearch\_domain\_name](#input\_opensearch\_domain\_name) | Base name for the OpenSearch domain; the example appends a random suffix. | `string` | `"test-tobs"` | no |
| <a name="input_opensearch_engine_version"></a> [opensearch\_engine\_version](#input\_opensearch\_engine\_version) | OpenSearch engine version. | `string` | `"OpenSearch_2.13"` | no |
| <a name="input_opensearch_instance_type"></a> [opensearch\_instance\_type](#input\_opensearch\_instance\_type) | OpenSearch instance type. | `string` | `"t3.small.search"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to module-managed resources. | `map(string)` | <pre>{<br/>  "Example": "basic",<br/>  "ManagedBy": "terraform",<br/>  "Module": "telemetry-observability"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarms_topic_arn"></a> [alarms\_topic\_arn](#output\_alarms\_topic\_arn) | Pass-through SNS topic ARN (null in the basic example). |
| <a name="output_grafana_workspace_arn"></a> [grafana\_workspace\_arn](#output\_grafana\_workspace\_arn) | Grafana workspace ARN. |
| <a name="output_grafana_workspace_id"></a> [grafana\_workspace\_id](#output\_grafana\_workspace\_id) | Grafana workspace identifier. |
| <a name="output_grafana_workspace_url"></a> [grafana\_workspace\_url](#output\_grafana\_workspace\_url) | Grafana workspace endpoint URL. |
| <a name="output_indexer_function_arn"></a> [indexer\_function\_arn](#output\_indexer\_function\_arn) | Indexer Lambda function ARN. |
| <a name="output_indexer_function_name"></a> [indexer\_function\_name](#output\_indexer\_function\_name) | Indexer Lambda function name. |
| <a name="output_opensearch_domain_arn"></a> [opensearch\_domain\_arn](#output\_opensearch\_domain\_arn) | ARN of the OpenSearch domain. |
| <a name="output_opensearch_domain_endpoint"></a> [opensearch\_domain\_endpoint](#output\_opensearch\_domain\_endpoint) | Endpoint URL of the OpenSearch domain. |
| <a name="output_opensearch_domain_name"></a> [opensearch\_domain\_name](#output\_opensearch\_domain\_name) | Name of the OpenSearch domain. |
