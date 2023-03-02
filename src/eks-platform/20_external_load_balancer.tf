module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = ">= 8.3.1"

  name = local.project
  load_balancer_type = "network"
  vpc_id  = var.vpc.id
  subnets = var.vpc.private_subnets_ids
}
