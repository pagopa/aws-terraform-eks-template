module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.19.0"

  name = local.project

  cidr           = var.cidr
  azs            = var.azs
  public_subnets = var.public_subnets_cidr

  enable_nat_gateway   = false
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
