# tf-module-dns-query-log

Terraform module to enable Route53 Resolver DNS query logging for a VPC.

This module creates:
- A KMS key with IAM policy for encrypting DNS query logs (includes CloudWatch Logs service permissions and optional Wiz role access)
- A KMS alias for the encryption key
- A CloudWatch Log Group for DNS query logs
- A Route53 Resolver query log configuration
- An association between the query log configuration and a target VPC

## Usage

```hcl
module "dns_query_log" {
  source = "git::https://github.com/Nets-Platform-Enablement/tf-module-dns-query-log.git?ref=main"

  # Only setup in "production" environment
  count  = var.environment == "production" ? 1 : 0

  name                  = "name-of-the-service"
  vpc_id                = module.vpc.vpc_id
  aws_region            = var.aws_region
  wiz_role_name         = var.wiz_role_name  # Optional
  log_retention_in_days = 30

  tags = {
    Environment = "dev"
    Project     = "networking"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix used for DNS query logging resources. | `string` | n/a | yes |
| vpc_id | ID of the VPC to associate with the Route53 Resolver query log config. | `string` | n/a | yes |
| aws_region | AWS region for KMS policy conditions. | `string` | n/a | yes |
| wiz_role_name | Name of the Wiz IAM role for security scanning. Will be granted kms:Decrypt and kms:DescribeKey permissions. | `string` | `""` | no |
| log_retention_in_days | Retention period in days for the CloudWatch log group. | `number` | `30` | no |
| tags | Tags to apply to all created resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| kms_key_id | ID of the KMS key used to encrypt DNS query logs. |
| kms_key_arn | ARN of the KMS key used to encrypt DNS query logs. |
| cloudwatch_log_group_name | Name of the CloudWatch log group receiving DNS query logs. |
| cloudwatch_log_group_arn | ARN of the CloudWatch log group receiving DNS query logs. |
| resolver_query_log_config_id | ID of the Route53 Resolver query log config. |
| resolver_query_log_config_arn | ARN of the Route53 Resolver query log config. |
| resolver_query_log_config_association_id | ID of the Route53 Resolver query log config association with the VPC. |
