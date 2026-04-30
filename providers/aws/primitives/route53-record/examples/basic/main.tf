resource "aws_route53_zone" "test" {
  name = var.zone_name
}

module "route53_record" {
  source = "../../"

  zone_id = aws_route53_zone.test.zone_id
  name    = var.record_name
  type    = var.record_type
  ttl     = var.ttl
  records = var.records
}

output "record_name" {
  description = "The name of the Route53 record"
  value       = module.route53_record.record_name
}

output "record_fqdn" {
  description = "The fully qualified domain name of the record"
  value       = module.route53_record.record_fqdn
}

output "record_type" {
  description = "The record type"
  value       = module.route53_record.record_type
}

output "record_zone_id" {
  description = "The zone ID of the hosted zone that contains the record"
  value       = module.route53_record.record_zone_id
}

output "record_ttl" {
  description = "The TTL of the record"
  value       = module.route53_record.record_ttl
}

output "zone_id" {
  description = "The zone ID of the test hosted zone"
  value       = aws_route53_zone.test.zone_id
}
