module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.19.0"

  name = local.project

  cidr                    = var.cidr
  azs                     = var.azs
  public_subnets          = var.public_subnets_cidr
  map_public_ip_on_launch = var.map_public_ip_on_launch

  enable_nat_gateway   = false
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
}
