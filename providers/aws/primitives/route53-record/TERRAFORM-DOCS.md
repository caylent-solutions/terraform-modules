## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias"></a> [alias](#input\_alias) | (Optional) An alias block for routing to AWS resources. Mutually exclusive with ttl and records. | <pre>object({<br/>    name                   = string<br/>    zone_id                = string<br/>    evaluate_target_health = bool<br/>  })</pre> | `null` | no |
| <a name="input_allow_overwrite"></a> [allow\_overwrite](#input\_allow\_overwrite) | (Optional) Allow creation of this record in Terraform to overwrite an existing record, if any. Defaults to false. | `bool` | `false` | no |
| <a name="input_failover_routing_policy"></a> [failover\_routing\_policy](#input\_failover\_routing\_policy) | (Optional) A block indicating the routing behavior when associated health check fails. Valid values: PRIMARY, SECONDARY. Requires set\_identifier. | <pre>object({<br/>    type = string<br/>  })</pre> | `null` | no |
| <a name="input_geolocation_routing_policy"></a> [geolocation\_routing\_policy](#input\_geolocation\_routing\_policy) | (Optional) A block indicating a routing policy based on the geolocation of the requestor. Requires set\_identifier. | <pre>object({<br/>    continent   = optional(string)<br/>    country     = optional(string)<br/>    subdivision = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_health_check_id"></a> [health\_check\_id](#input\_health\_check\_id) | (Optional) The health check the record should be associated with. | `string` | `null` | no |
| <a name="input_latency_routing_policy"></a> [latency\_routing\_policy](#input\_latency\_routing\_policy) | (Optional) A block indicating a routing policy based on the latency between the requestor and an AWS region. Requires set\_identifier. | <pre>object({<br/>    region = string<br/>  })</pre> | `null` | no |
| <a name="input_multivalue_answer_routing_policy"></a> [multivalue\_answer\_routing\_policy](#input\_multivalue\_answer\_routing\_policy) | (Optional) Set to true to indicate a multivalue answer routing policy. Requires set\_identifier. | `bool` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the record. Do not include a trailing dot. | `string` | n/a | yes |
| <a name="input_records"></a> [records](#input\_records) | (Optional) A string list of records. Required when not using an alias block. Mutually exclusive with alias. | `list(string)` | `null` | no |
| <a name="input_set_identifier"></a> [set\_identifier](#input\_set\_identifier) | (Optional) Unique identifier to differentiate records with routing policies. Required for failover, geolocation, latency, and weighted routing policies. | `string` | `null` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | (Optional) The TTL of the record in seconds. Required when not using an alias block. Mutually exclusive with alias. | `number` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | (Required) The record type. Valid values: A, AAAA, CAA, CNAME, DS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, TXT. | `string` | n/a | yes |
| <a name="input_weighted_routing_policy"></a> [weighted\_routing\_policy](#input\_weighted\_routing\_policy) | (Optional) A block indicating a weighted routing policy. Requires set\_identifier. | <pre>object({<br/>    weight = number<br/>  })</pre> | `null` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | (Required) The ID of the hosted zone in which to create the record. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_record_fqdn"></a> [record\_fqdn](#output\_record\_fqdn) | The fully qualified domain name of the record |
| <a name="output_record_name"></a> [record\_name](#output\_record\_name) | The name of the Route53 record |
| <a name="output_record_ttl"></a> [record\_ttl](#output\_record\_ttl) | The TTL of the record |
| <a name="output_record_type"></a> [record\_type](#output\_record\_type) | The record type |
| <a name="output_record_zone_id"></a> [record\_zone\_id](#output\_record\_zone\_id) | The zone ID of the hosted zone that contains the record |
