data "aws_secretsmanager_secret" "pg-secret-arn" {
  arn = var.pg_secret_arn
}

data "aws_secretsmanager_secret_version" "pg-secret-id" {
  secret_id = data.aws_secretsmanager_secret.pg-secret-arn.id
}

locals {
  username = jsondecode(data.aws_secretsmanager_secret_version.pg-secret-id.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.pg-secret-id.secret_string)["password"]
  port = jsondecode(data.aws_secretsmanager_secret_version.pg-secret-id.secret_string)["port"]
}

resource "aws_db_subnet_group" "pg-subnets" {
  name = "pg-public-subnet-group"
  subnet_ids = var.public_subnet_ids
}

module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = var.database_name

  create_db_option_group = false
  create_db_parameter_group = false

  engine         = "postgres"
  engine_version = "13.3"
  family         = "postgres13"
  instance_class = "db.t4g.micro"
  storage_type   = "standard"
  allocated_storage = 20
  apply_immediately = true

  name = "postgres"
  username = local.username
  password = local.password
  port = local.port
  publicly_accessible = true

  multi_az = false

  iam_database_authentication_enabled = false
  vpc_security_group_ids = var.security_group_ids

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  tags = {
    terraform = "true"
  }

  subnet_ids = var.public_subnet_ids
  deletion_protection = false
}