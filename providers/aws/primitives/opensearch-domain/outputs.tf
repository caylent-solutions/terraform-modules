output "domain_arn" {
  description = "ARN of the OpenSearch domain."
  value       = aws_opensearch_domain.this.arn
}

output "domain_id" {
  description = "ID of the OpenSearch domain (e.g. `arn:aws:es:...:domain/<id>`)."
  value       = aws_opensearch_domain.this.domain_id
}

output "domain_name" {
  description = "Name of the OpenSearch domain."
  value       = aws_opensearch_domain.this.domain_name
}

output "endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests."
  value       = aws_opensearch_domain.this.endpoint
}

output "kibana_endpoint" {
  description = "Domain-specific endpoint for the OpenSearch Dashboards (Kibana) UI."
  value       = aws_opensearch_domain.this.kibana_endpoint
}

output "log_group_arn" {
  description = "ARN of the auto-created application log CloudWatch Log Group."
  value       = aws_cloudwatch_log_group.application.arn
}
