variable "environment" {
  description = "Deployment environment (e.g., production, development)"
  type        = string
}

variable "task_cpu" {
  description = "The amount of CPU to allocate for the task"
  type        = string
}

variable "task_memory" {
  description = "The amount of memory to allocate for the task"
  type        = string
}

variable "container_cpu" {
  description = "The amount of CPU to allocate for the container"
  type        = number
}

variable "container_memory" {
  description = "The amount of memory to allocate for the container"
  type        = number
}

variable "min_capacity" {
  description = "The number of instances of the task min definition to place and keep running"
  type        = number
}

variable "max_capacity" {
  description = "The number of instances of the task max definition to place and keep running"
  type        = number
}

variable "desired_count" {
  description = "The number of instances of the task desired_count to place and keep running"
  type        = number
}

variable "subnets" {
  description = "Subnets for the ECS tasks"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}
variable "service_name" {
  description = "Service name"
  type        = string
}

variable "port_http" {
  description = "Number port http"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group for load balancing"
  type        = string
}
