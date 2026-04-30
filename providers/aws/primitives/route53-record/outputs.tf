output "record_name" {
  description = "The name of the Route53 record"
  value       = aws_route53_record.record.name
}

output "record_fqdn" {
  description = "The fully qualified domain name of the record"
  value       = aws_route53_record.record.fqdn
}

output "record_type" {
  description = "The record type"
  value       = aws_route53_record.record.type
}

output "record_zone_id" {
  description = "The zone ID of the hosted zone that contains the record"
  value       = aws_route53_record.record.zone_id
}

output "record_ttl" {
  description = "The TTL of the record"
  value       = aws_route53_record.record.ttl
}
