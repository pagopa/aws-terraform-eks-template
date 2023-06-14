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
        status_code  = 403
        content_type = "text/plain"
      }
    }
  ]
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


data "aws_network_interface" "nlb" {
  for_each = toset(aws_subnet.this[*].id)

  filter {
    name   = "description"
    values = ["ELB ${module.nlb.lb_arn_suffix}"]
  }

  filter {
    name   = "interface-type"
    values = ["network_load_balancer"]
  }

  filter {
    name   = "subnet-id"
    values = [each.value]
  }
}

resource "aws_security_group_rule" "allow_nlb_connections" {
  security_group_id = module.alb.security_group_id
  description       = "Allow access from NLB"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [for eni in data.aws_network_interface.nlb : "${eni.private_ip}/32"]
}
