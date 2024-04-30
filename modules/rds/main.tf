resource "aws_db_instance" "dbRds" {
  identifier        = "${var.environment}-rds-db"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  engine            = "mysql"
  engine_version    = "5.7"
  username          = var.db_username
  password          = var.db_password

  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  multi_az               = var.multi_az

  backup_retention_period = var.backup_retention_period
  storage_encrypted       = true
  skip_final_snapshot     = var.skip_final_snapshot

  tags = {
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group-${var.environment}"
  subnet_ids = var.subnet_ids

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-${var.environment}"
  description = "Security group for RDS ${var.environment} environment"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [var.ecs_security_group_id]  # Allow only ECS to access the database
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}

