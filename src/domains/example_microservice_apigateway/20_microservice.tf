data "aws_secretsmanager_secret" "my_secret" {
  name = "dvopla-example-microservice-apigateway"
}

data "aws_secretsmanager_secret_version" "my_secret" {
  secret_id = data.aws_secretsmanager_secret.my_secret.id
}

resource "helm_release" "echoserver" {
  name      = var.app_name
  namespace = kubernetes_namespace.this.id

  # TODO: use GH https://github.com/pagopa/eks-microservice-chart-blueprint
  repository = "${path.module}/../../../../eks-microservice-chart-blueprint/charts"
  chart      = "microservice-chart"
  version    = "0.1.0"

  values = ["${file("assets/configuration.yaml")}"]

  set {
    name  = "env.MY_SECRETa"
    value = data.aws_secretsmanager_secret_version.my_secret.secret_string
  }

  set {
    name  = "image.securityGroupIds[0]"
    value = var.cluster_security_group_id
  }

  set {
    name  = "service.targetGroupArn"
    value = aws_lb_target_group.echoserver.arn
  }
}
