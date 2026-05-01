# Basic Example Documentation

<!-- BEGIN_TF_DOCS -->
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
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_record_a"></a> [record\_a](#module\_record\_a) | ../../ | n/a |
| <a name="module_record_cname"></a> [record\_cname](#module\_record\_cname) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_vpc.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the test VPC and hosted zone. | `map(string)` | `{}` | no |
| <a name="input_zone_name_prefix"></a> [zone\_name\_prefix](#input\_zone\_name\_prefix) | Base zone name prefix (a random suffix is appended); the zone is created as `<prefix>-<suffix>.internal` in a fresh test VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_record_a_fqdn"></a> [record\_a\_fqdn](#output\_record\_a\_fqdn) | FQDN of the A record. |
| <a name="output_record_cname_fqdn"></a> [record\_cname\_fqdn](#output\_record\_cname\_fqdn) | FQDN of the CNAME record. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Test private hosted zone id. |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | Test private hosted zone name. |
<!-- END_TF_DOCS -->