module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = ">= 8.3.1"

  name = local.project
  load_balancer_type = "network"
  vpc_id  = var.vpc.id
  subnets = var.vpc.private_subnets_ids

  target_groups = [
    {
      name_prefix      = "${substr(local.project, 0, 5)}-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "ip"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    }
  ]
}
