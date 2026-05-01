resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_vpc" "test" {
  cidr_block = "10.99.0.0/16"
  tags       = merge(var.tags, { Name = "${var.zone_name_prefix}-${random_id.suffix.hex}" })
}

resource "aws_route53_zone" "test" {
  name = "${var.zone_name_prefix}-${random_id.suffix.hex}.internal"

  vpc {
    vpc_id = aws_vpc.test.id
  }

  tags = var.tags
}

module "record_a" {
  source = "../../"

  zone_id = aws_route53_zone.test.id
  name    = "api.${aws_route53_zone.test.name}"
  type    = "A"
  ttl     = 60
  records = ["10.99.1.10", "10.99.1.11"]
}

module "record_cname" {
  source = "../../"

  zone_id = aws_route53_zone.test.id
  name    = "alias.${aws_route53_zone.test.name}"
  type    = "CNAME"
  ttl     = 60
  records = ["api.${aws_route53_zone.test.name}"]
}

output "zone_id" {
  description = "Test private hosted zone id."
  value       = aws_route53_zone.test.id
}

output "zone_name" {
  description = "Test private hosted zone name."
  value       = aws_route53_zone.test.name
}

output "record_a_fqdn" {
  description = "FQDN of the A record."
  value       = module.record_a.fqdn
}

output "record_cname_fqdn" {
  description = "FQDN of the CNAME record."
  value       = module.record_cname.fqdn
}
