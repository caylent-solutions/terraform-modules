## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_opensearch_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |
| [aws_iam_policy_document.application_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies_json"></a> [access\_policies\_json](#input\_access\_policies\_json) | Domain access policy as a JSON-encoded string. Null lets AWS apply the default open-to-everyone policy (only safe for VPC-mode domains). | `string` | `null` | no |
| <a name="input_advanced_security_master_user_arn"></a> [advanced\_security\_master\_user\_arn](#input\_advanced\_security\_master\_user\_arn) | IAM ARN to use as the master user when fine-grained access control is enabled (`advanced_security_options`). Null disables fine-grained access control. | `string` | `null` | no |
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | Number of AZs (2 or 3) when zone\_awareness\_enabled = true. | `number` | `2` | no |
| <a name="input_custom_endpoint"></a> [custom\_endpoint](#input\_custom\_endpoint) | Custom endpoint hostname (used when custom\_endpoint\_enabled = true). | `string` | `null` | no |
| <a name="input_custom_endpoint_certificate_arn"></a> [custom\_endpoint\_certificate\_arn](#input\_custom\_endpoint\_certificate\_arn) | ACM certificate ARN for the custom endpoint (used when custom\_endpoint\_enabled = true). | `string` | `null` | no |
| <a name="input_custom_endpoint_enabled"></a> [custom\_endpoint\_enabled](#input\_custom\_endpoint\_enabled) | Whether to use a custom endpoint (vanity hostname) for the domain. | `bool` | `false` | no |
| <a name="input_dedicated_master_count"></a> [dedicated\_master\_count](#input\_dedicated\_master\_count) | Count of dedicated master nodes (3 or 5; only used when dedicated\_master\_enabled = true). | `number` | `3` | no |
| <a name="input_dedicated_master_enabled"></a> [dedicated\_master\_enabled](#input\_dedicated\_master\_enabled) | Whether to provision dedicated master nodes. | `bool` | `false` | no |
| <a name="input_dedicated_master_type"></a> [dedicated\_master\_type](#input\_dedicated\_master\_type) | Instance type for dedicated master nodes (only used when dedicated\_master\_enabled = true). | `string` | `"t3.small.search"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Name of the OpenSearch domain. Must be 3-28 characters, lowercase alphanumerics and hyphens, starting with a letter. | `string` | n/a | yes |
| <a name="input_ebs_iops"></a> [ebs\_iops](#input\_ebs\_iops) | Provisioned IOPS for the EBS volume (only meaningful for gp3/io1). | `number` | `null` | no |
| <a name="input_ebs_throughput"></a> [ebs\_throughput](#input\_ebs\_throughput) | Provisioned throughput in MiB/s for gp3 volumes. | `number` | `null` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | EBS volume size per data node in GB. | `number` | `10` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | EBS volume type for data nodes. gp3 or gp2. | `string` | `"gp3"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | OpenSearch engine version (e.g. `OpenSearch_2.13`). | `string` | `"OpenSearch_2.13"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of data node instances. | `number` | `1` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for data nodes (e.g. `t3.small.search`, `r6g.large.search`). | `string` | `"t3.small.search"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key id, alias, or ARN for encryption at rest. When null, the AWS-managed key `aws/es` is used. | `string` | `null` | no |
| <a name="input_log_kms_key_arn"></a> [log\_kms\_key\_arn](#input\_log\_kms\_key\_arn) | KMS key ARN to encrypt the application log group. Null uses AWS-managed encryption. | `string` | `null` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Retention for the auto-created application log group. | `number` | `30` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the domain, log group, and log resource policy. | `map(string)` | `{}` | no |
| <a name="input_tls_security_policy"></a> [tls\_security\_policy](#input\_tls\_security\_policy) | TLS security policy for the domain endpoint. | `string` | `"Policy-Min-TLS-1-2-PFS-2023-10"` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of security group ids for the VPC-mode domain ENIs. | `list(string)` | `[]` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | List of VPC subnet ids for VPC-mode domains. Null disables VPC mode (public domain). VPC mode requires the subnets to span the configured AZ count and the domain must be deleted/recreated to switch modes. | `list(string)` | `null` | no |
| <a name="input_zone_awareness_enabled"></a> [zone\_awareness\_enabled](#input\_zone\_awareness\_enabled) | Spread data nodes across multiple AZs. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_arn"></a> [domain\_arn](#output\_domain\_arn) | ARN of the OpenSearch domain. |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | ID of the OpenSearch domain (e.g. `arn:aws:es:...:domain/<id>`). |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | Name of the OpenSearch domain. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Domain-specific endpoint used to submit index, search, and data upload requests. |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | Domain-specific endpoint for the OpenSearch Dashboards (Kibana) UI. |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | ARN of the auto-created application log CloudWatch Log Group. |
