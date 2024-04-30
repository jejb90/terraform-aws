output "development_vpc_id" {
  value = module.vpc.vpc_id
}

output "development_public_subnets" {
  value = module.vpc.public_subnets
}

output "development_private_subnets" {
  value = module.vpc.private_subnets
}


output "development_alb_arn" {
  value = module.alb.alb_arn
}

output "development_rds_endpoint" {
  value = module.rds.db_instance_endpoint
}
