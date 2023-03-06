module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = ">= 8.3.1"

  name               = local.project
  load_balancer_type = "network"
  vpc_id             = var.vpc.id
  subnets            = var.vpc.private_subnets_ids
}

resource "aws_security_group" "allow_from_nlb" {
  name_prefix = "${local.project}-allow-from-nlb-"
  description = "Allow inbound traffic from K8s NLB"
  vpc_id      = var.vpc.id
}

resource "aws_security_group_rule" "allow_from_nlb" {
  security_group_id = aws_security_group.allow_from_nlb.id

  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
  source_security_group_id = module.nlb.security_group_id
}
