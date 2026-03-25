output "kms_key_id" {
  description = "ID of the KMS key used to encrypt DNS query logs."
  value       = aws_kms_key.dns_query_logs.key_id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt DNS query logs."
  value       = aws_kms_key.dns_query_logs.arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group receiving DNS query logs."
  value       = aws_cloudwatch_log_group.dns_query_logs.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group receiving DNS query logs."
  value       = aws_cloudwatch_log_group.dns_query_logs.arn
}

output "resolver_query_log_config_id" {
  description = "ID of the Route53 Resolver query log config."
  value       = aws_route53_resolver_query_log_config.vpc.id
}

output "resolver_query_log_config_arn" {
  description = "ARN of the Route53 Resolver query log config."
  value       = aws_route53_resolver_query_log_config.vpc.arn
}

output "resolver_query_log_config_association_id" {
  description = "ID of the Route53 Resolver query log config association with the VPC."
  value       = aws_route53_resolver_query_log_config_association.vpc.id
}
