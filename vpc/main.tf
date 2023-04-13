module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name = var.project_name
  cidr = "10.0.0.0/16"

  azs  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  single_nat_gateway   = true
  one_nat_gateway_per_az  = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    terraform = "true"
    environment = var.env
  }
}