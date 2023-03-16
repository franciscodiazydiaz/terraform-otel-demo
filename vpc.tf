module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = local.name

  cidr = var.vpc_cidr_block
  azs  = local.azs

  private_subnets = [for n in range(length(local.azs)) : cidrsubnet(var.vpc_cidr_block, 8, n)]       # 10.0.x.0/24
  public_subnets  = [for n in range(length(local.azs)) : cidrsubnet(var.vpc_cidr_block, 8, 100 + n)] # 10.0.10x.0/24

  enable_nat_gateway     = true
  single_nat_gateway     = var.environment == "dev" ? true : false
  one_nat_gateway_per_az = false

  # Required by the EC2 VPC Endpoint
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}
