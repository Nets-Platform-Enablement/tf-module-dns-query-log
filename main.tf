locals {
  tags = merge(var.tags, {
    Module = "tf-module-dns-query-log"
  })
}

################################################################################
# Route53 Resolver Query Logging
################################################################################

# KMS key for DNS query logs encryption
resource "aws_kms_key" "dns_query_logs" {
  description             = "KMS key for Route53 Resolver Query Logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = local.tags
}

resource "aws_kms_alias" "dns_query_logs" {
  name          = "alias/dns_query_logs"
  target_key_id = aws_kms_key.dns_query_logs.key_id
}

# CloudWatch Log Group for DNS queries
resource "aws_cloudwatch_log_group" "dns_query_logs" {
  name              = "/aws/route53/${var.name}-vpc-dns-queries"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = aws_kms_key.dns_query_logs.arn
  tags              = local.tags
}

# Route53 Resolver Query Log Config
resource "aws_route53_resolver_query_log_config" "vpc" {
  name            = "${var.name}-dns-query-logs"
  destination_arn = aws_cloudwatch_log_group.dns_query_logs.arn
  tags            = local.tags
}

# Associate query logging with VPC
resource "aws_route53_resolver_query_log_config_association" "vpc" {
  resolver_query_log_config_id = aws_route53_resolver_query_log_config.vpc.id
  resource_id                  = var.vpc_id
}