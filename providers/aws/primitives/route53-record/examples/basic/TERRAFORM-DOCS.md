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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_route53_record"></a> [route53\_record](#module\_route53\_record) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_record_name"></a> [record\_name](#input\_record\_name) | The name of the DNS record to create | `string` | `"api.caylent-terratest-r53-record.net"` | no |
| <a name="input_record_type"></a> [record\_type](#input\_record\_type) | The type of the DNS record | `string` | `"A"` | no |
| <a name="input_records"></a> [records](#input\_records) | A list of record values | `list(string)` | <pre>[<br/>  "1.2.3.4"<br/>]</pre> | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | The TTL of the record in seconds | `number` | `300` | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | The DNS name of the hosted zone to create for testing | `string` | `"caylent-terratest-r53-record.net"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_record_fqdn"></a> [record\_fqdn](#output\_record\_fqdn) | The fully qualified domain name of the record |
| <a name="output_record_name"></a> [record\_name](#output\_record\_name) | The name of the Route53 record |
| <a name="output_record_ttl"></a> [record\_ttl](#output\_record\_ttl) | The TTL of the record |
| <a name="output_record_type"></a> [record\_type](#output\_record\_type) | The record type |
| <a name="output_record_zone_id"></a> [record\_zone\_id](#output\_record\_zone\_id) | The zone ID of the hosted zone that contains the record |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The zone ID of the test hosted zone |
