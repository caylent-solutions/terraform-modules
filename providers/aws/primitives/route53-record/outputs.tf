output "name" {
  description = "Final fully-qualified record name (Route53 normalizes this to FQDN with trailing dot)."
  value       = aws_route53_record.this.name
}

output "fqdn" {
  description = "FQDN of the record (Route53-computed)."
  value       = aws_route53_record.this.fqdn
}

output "type" {
  description = "Record type."
  value       = aws_route53_record.this.type
}

output "zone_id" {
  description = "Hosted zone id where the record lives."
  value       = aws_route53_record.this.zone_id
}
