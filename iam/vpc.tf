module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.3"

  name = var.network.name
  cidr = var.network.cidr

  azs             = var.network.availability_zones
  
  private_subnets = var.network.private_subnets

  public_subnets  = var.network.public_subnets

  enable_nat_gateway     = var.network.enable_nat_gateway
  single_nat_gateway     = var.network.single_nat_gateway
  one_nat_gateway_per_az = var.network.one_nat_gateway_per_az

  enable_dns_hostnames = var.network.enable_dns_hostnames
  enable_dns_support   = var.network.enable_dns_support

  tags = {
    Environment = var.network.tags_env
  }
}
