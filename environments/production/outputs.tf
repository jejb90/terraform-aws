output "production_vpc_id" {
  value = module.vpc.vpc_id
}

output "production_public_subnets" {
  value = module.vpc.public_subnets
}

output "production_private_subnets" {
  value = module.vpc.private_subnets
}


output "production_alb_arn" {
  value = module.alb.alb_arn
}

output "production_rds_endpoint" {
  value = module.rds.db_instance_endpoint
}
