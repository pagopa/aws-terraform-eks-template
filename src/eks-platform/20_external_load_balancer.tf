module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = ">= 8.3.1"

  name               = local.project
  internal           = true
  load_balancer_type = "network"
  vpc_id             = var.vpc_id
  subnets            = aws_subnet.this[*].id
}

data "aws_network_interface" "nlb_eni" {
  for_each = tomap({ for k, v in aws_subnet.this[*].id: k => v })

  filter {
    name   = "description"
    values = ["ELB ${module.nlb.lb_arn_suffix}"]
  }

  filter {
    name   = "subnet-id"
    values = [each.value]
  }
}
