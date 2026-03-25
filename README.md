# tf-module-dns-query-log

Terraform module to enable Route53 Resolver DNS query logging for a VPC.

This module creates:
- A KMS key and alias for encrypting DNS query logs
- A CloudWatch Log Group for DNS query logs
- A Route53 Resolver query log configuration
- An association between the query log configuration and a target VPC

## Usage

```hcl
module "dns_query_log" {
  source = "git::https://github.com/Nets-Platform-Enablement/tf-module-aws-infra-pipeline?ref=ea7a6a9"

  # Only setup in "production" environment
  count  = var.environment == "production" ? 1 : 0

  name   = "name-of-the-service"
  vpc_id = module.vpc.vpc_id

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
