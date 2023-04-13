variable "pg_secret_arn" {
  type = string
  description = "The ARN that relates to the secret for the database instance"
}

variable "database_name" {
  type = string
  description = "The name of the database"
}

variable "security_group_ids" {
  description = "The security groups that allow inbound traffic into the database"
}

variable "public_subnet_ids" {
  description = "The list of public subnets that can be used for the database cluster"
}