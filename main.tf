terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.36.0"
    }
  }

  backend "s3" {
    bucket = "luventure-terraform-state"
    key = "all"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  env = "DEV"
  snake_project_name = "luventure"
  dash_project_name = "event-luventure"
  database_name = "${local.dash_project_name}-db"
}

module "networking" {
  source = "./vpc"
  env = local.env
  project_name = local.snake_project_name
}


module "database" {
  source  = "./rds"
  pg_secret_arn = "arn:aws:secretsmanager:us-east-1:527761931337:secret:luventure-db-secret-8KCxJ5"
  database_name = local.database_name
  public_subnet_ids = module.networking.network.public_subnets
  security_group_ids = [module.networking.postgres_db_security_group_id]
}