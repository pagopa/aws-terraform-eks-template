resource "aws_lb_target_group" "this" {
  name_prefix = "${substr(local.project, 0, 5)}-"
  port        = var.port
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.cluster_vpc_id

  health_check {
    enabled             = true
    protocol            = "TCP"
    healthy_threshold   = 2
    interval            = 5
    unhealthy_threshold = 2
    timeout             = 4
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = var.cluster_nlb_arn
  protocol          = "TCP"
  port              = var.port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
