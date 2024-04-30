output "db_instance_identifier" {
  value = aws_db_instance.dbRds.identifier
}

output "db_instance_address" {
  value = aws_db_instance.dbRds.address
}

output "db_instance_endpoint" {
  value = aws_db_instance.dbRds.endpoint
}

output "db_instance_sg_id" {
  value = aws_security_group.rds_sg.id
}

