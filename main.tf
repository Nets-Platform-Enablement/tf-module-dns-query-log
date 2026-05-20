locals {
  tags = merge(var.tags, {
    Module = "tf-module-dns-query-log"
  })
}

data "aws_caller_identity" "current" {}

################################################################################
# Route53 Resolver Query Logging
################################################################################

# KMS key for DNS query logs encryption
resource "aws_kms_key" "dns_query_logs" {
  description             = "KMS key for Route53 Resolver Query Logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Enable KMS Permission for CloudWatch Logs"
        Effect = "Allow"
        Principal = {
          Service = "logs.${var.aws_region}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
        Condition = {
          ArnEquals = {
            "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
      ],
      var.wiz_role_name != "" ? [
        {
          Sid    = "AllowWizKMSDecrypt"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.wiz_role_name}"
          }
          Action = [
            "kms:Decrypt",
            "kms:DescribeKey"
          ]
          Resource = "*"
        }
    ] : [])
  })
  tags = local.tags
}

resource "aws_kms_alias" "dns_query_logs" {
  name          = "alias/dns_query_logs-${var.name}"
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
