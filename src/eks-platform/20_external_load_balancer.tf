module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = ">= 8.3.1"

  enable_deletion_protection = true

  name               = "${local.project}-alb"
  internal           = true
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = aws_subnet.this[*].id

  security_group_rules = {
    ingress_all_http = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP web traffic"
      # source_security_group_id = module.nlb.security_group_id
      cidr_blocks = ["0.0.0.0/0"]
    },
    egress_all = {
      type        = "egress"
      from_port   = 1
      to_port     = 65535
      protocol    = "tcp"
      description = "All traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "fixed-response"

      fixed_response = {
        status_code  = 404
        content_type = "text/plain"
      }
    }
  ]

  tags = {
    "elbv2.k8s.aws/cluster"    = module.eks.cluster_name
    "ingress.k8s.aws/resource" = "80"
    "ingress.k8s.aws/stack"    = "${local.project}-alb"
  }
}

module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = ">= 8.3.1"

  enable_deletion_protection = true

  name               = "${local.project}-nlb"
  internal           = true
  load_balancer_type = "network"
  vpc_id             = var.vpc_id
  subnets            = aws_subnet.this[*].id

  http_tcp_listeners = [
    {
      port     = 80
      protocol = "TCP"
    }
  ]

  target_groups = [
    {
      name_prefix      = "alb-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "alb"
      targets = {
        alb = {
          target_id = module.alb.lb_id
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        matcher             = "200-499"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
    }
  ]
}
