output "network" {
  value = module.vpc
}

output "postgres_db_security_group_id" {
  value = aws_security_group.allow_5432.id
}
