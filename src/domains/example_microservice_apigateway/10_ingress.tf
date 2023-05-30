data "aws_secretsmanager_secret" "apigw_token" {
  name = "${var.app_name}-token"
}

data "aws_secretsmanager_secret_version" "apigw_token" {
  secret_id = data.aws_secretsmanager_secret.apigw_token.id
}

resource "aws_lb_target_group" "echoserver" {
  name        = var.app_name
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener_rule" "echoserver" {
  listener_arn = var.alb_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.echoserver.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    http_header {
      http_header_name = "X-ApiGw-Token"
      values           = [data.aws_secretsmanager_secret_version.apigw_token.secret_string]
    }
  }
}
