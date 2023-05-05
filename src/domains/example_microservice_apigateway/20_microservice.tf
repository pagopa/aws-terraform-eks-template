data "aws_secretsmanager_secret" "my_secret" {
  name = "dvopla-example-microservice-apigateway"
}

data "aws_secretsmanager_secret_version" "my_secret" {
  secret_id = data.aws_secretsmanager_secret.my_secret.id
}

resource "helm_release" "echoserver" {
  name      = var.app_name
  namespace = kubernetes_namespace.this.id

  repository = "${path.module}/../../../../eks-microservice-chart-blueprint/charts"
  chart      = "microservice-chart"
  version    = "0.1.0"

  values = ["${file("assets/configuration.yaml")}"]

  set {
    name  = "env.MY_SECRET"
    value = data.aws_secretsmanager_secret_version.my_secret.secret_string
  }
}
