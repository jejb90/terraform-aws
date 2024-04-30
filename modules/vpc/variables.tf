variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnets_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones in which to place subnets"
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment (e.g., production, development)"
  type        = string
}
