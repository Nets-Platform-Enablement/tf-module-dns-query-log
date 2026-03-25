variable "name" {
  description = "Name prefix used for DNS query logging resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to associate with the Route53 Resolver query log config."
  type        = string
}

variable "log_retention_in_days" {
  description = "Retention period in days for the CloudWatch log group."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to all created resources."
  type        = map(string)
  default     = {}
}
