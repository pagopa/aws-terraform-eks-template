resource "helm_release" "echoserver" {
  name      = var.app_name
  namespace = var.namespace

  repository = "${path.module}/../../../../eks-microservice-chart-blueprint/charts"
  chart      = "microservice-chart"
  version    = "0.1.0"

  set {
    name = "image.repository"
    value = "k8s.gcr.io/echoserver"
  }

  set {
    name = "image.tag"
    value = "1.10"
  }

  set {
    name = "image.port"
    value = 8080
  }

  set {
    name = "targetGroupBinding.create"
    value = true
  }

  set {
    name = "targetGroupBinding.arn"
    value = aws_lb_target_group.this.arn
  }

  lifecycle {
    replace_triggered_by = [aws_lb_target_group.this.arn]
  }
}
