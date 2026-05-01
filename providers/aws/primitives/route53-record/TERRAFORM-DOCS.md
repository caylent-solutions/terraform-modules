## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias"></a> [alias](#input\_alias) | Alias target. When set, `ttl` and `records` are ignored. `{ name, zone_id, evaluate_target_health }`. Mutually exclusive with the records+ttl path. | <pre>object({<br/>    name                   = string<br/>    zone_id                = string<br/>    evaluate_target_health = bool<br/>  })</pre> | `null` | no |
| <a name="input_failover_routing_policy"></a> [failover\_routing\_policy](#input\_failover\_routing\_policy) | Failover routing policy: `{ type = "PRIMARY"|"SECONDARY" }`. Mutually exclusive with other routing policies. | <pre>object({<br/>    type = string<br/>  })</pre> | `null` | no |
| <a name="input_geolocation_routing_policy"></a> [geolocation\_routing\_policy](#input\_geolocation\_routing\_policy) | Geolocation routing policy: `{ continent, country, subdivision }`. At least one of the three MUST be set when this policy is used. | <pre>object({<br/>    continent   = optional(string)<br/>    country     = optional(string)<br/>    subdivision = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_health_check_id"></a> [health\_check\_id](#input\_health\_check\_id) | Optional Route53 health check ID. | `string` | `null` | no |
| <a name="input_latency_routing_policy"></a> [latency\_routing\_policy](#input\_latency\_routing\_policy) | Latency routing policy: `{ region = AWS region }`. Mutually exclusive with other routing policies. | <pre>object({<br/>    region = string<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Record name (DNS name). May be relative (`api`) or fully-qualified (`api.example.com.`). | `string` | n/a | yes |
| <a name="input_records"></a> [records](#input\_records) | List of record values (rdata). Required (non-empty) when alias is null; must be empty when alias is set. Cross-variable validation enforces this. | `list(string)` | `[]` | no |
| <a name="input_set_identifier"></a> [set\_identifier](#input\_set\_identifier) | Optional identifier for routing-policy records (weighted/failover/latency/geolocation). | `string` | `null` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | Record TTL in seconds. Required when alias is null. Ignored when alias is set. Must not be null. | `number` | `300` | no |
| <a name="input_type"></a> [type](#input\_type) | Record type. One of A, AAAA, CNAME, CAA, MX, NAPTR, NS, PTR, SOA, SPF, SRV, TXT. | `string` | n/a | yes |
| <a name="input_weighted_routing_policy"></a> [weighted\_routing\_policy](#input\_weighted\_routing\_policy) | Weighted routing policy: `{ weight = number }`. Mutually exclusive with the other routing policies (validation enforced on this variable). | <pre>object({<br/>    weight = number<br/>  })</pre> | `null` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Hosted zone id where the record is created. The zone must already exist; this primitive does not provision the zone. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | FQDN of the record (Route53-computed). |
| <a name="output_name"></a> [name](#output\_name) | Final fully-qualified record name (Route53 normalizes this to FQDN with trailing dot). |
| <a name="output_type"></a> [type](#output\_type) | Record type. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Hosted zone id where the record lives. |
