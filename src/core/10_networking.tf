module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.19.0"

  name = local.project
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.vpc_public_subnets_cidr
  private_subnets = var.vpc_private_subnets_cidr

  enable_nat_gateway     = length(var.vpc_private_subnets_cidr) > 0
  single_nat_gateway     = var.vpc_enable_single_nat_gateway
  one_nat_gateway_per_az = !var.vpc_enable_single_nat_gateway

  enable_dns_hostnames     = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

