variable "environment" {
  description = "Deployment environment (e.g., production, development)"
  type        = string
}

variable "instance_class" {
  description = "DB instance class"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
}

variable "db_username" {
  description = "Username for the database administrator"
  type        = string
}

variable "db_password" {
  description = "Password for the database administrator"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the RDS instance is to be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the RDS instance"
  type        = string
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
}

variable "ecs_security_group_id" {
  description = "Security group ID of the ECS instances"
  type        = string
}

