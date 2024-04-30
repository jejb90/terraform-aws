variable "environment" {
  description = "The deployment environment (e.g., production, development)"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID to attach to the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB is deployed"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate for HTTPS listener"
  type        = string
}

