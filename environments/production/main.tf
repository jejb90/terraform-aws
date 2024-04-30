module "vpc" {
  source = "../../modules/vpc"
  cidr_block = "10.0.0.0/16"
  public_subnets_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones    = ["us-east-1a", "us-east-1b"]
  environment           = "production"
}

module "alb" {
  source            = "../../modules/alb"
  environment       = "production"
  subnets           = module.vpc.public_subnets
  security_group_id = module.vpc.security_group_id
  vpc_id            = module.vpc.vpc_id
  certificate_arn   = "arn:aws:acm:us-east-1:471112768670:certificate/db0ba592-07c5-435f-8afc-51b58cab5b75"
}

data "aws_secretsmanager_secret" "rds_credentials" {
  name = "rds/credentials-prod"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.rds_credentials.id
}

module "rds" {
  source                = "../../modules/rds"
  environment           = "production"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  db_username           = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["username"]
  db_password           = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["password"]
  db_name               = "database"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnets
  security_group_id     = module.rds.db_instance_sg_id
  multi_az              = true
  backup_retention_period = 7
  skip_final_snapshot   = false
  ecs_security_group_id = module.vpc.security_group_id
}

module "ecs" {
  source            = "../../modules/ecs"
  service_name = "prod-serv"
  environment       = "production"
  task_cpu          = "256"
  task_memory       = "512"
  container_cpu     = 256
  container_memory  = 512
  desired_count     = 0
  subnets           = module.vpc.public_subnets
  security_group_id = module.vpc.security_group_id
  target_group_arn  = module.alb.target_group_arn
  min_capacity = 0
  max_capacity = 0
  port_http = 80
}
