resource "kubernetes_deployment" "echoserver" {
  count = var.create_echo_server ? 1 : 0

  metadata {
    name      = "echoserver"
    namespace = kubernetes_namespace.default.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "echoserver"
      }
    }

    template {
      metadata {
        labels = {
          app = "echoserver"
        }
      }

      spec {
        container {
          image = "k8s.gcr.io/echoserver:1.10"
          name  = "echoserver"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "echoserver" {
  count = var.create_echo_server ? 1 : 0

  metadata {
    name      = "echoserver"
    namespace = kubernetes_namespace.default.metadata.0.name
  }

  spec {
    selector = {
      app = "echoserver"
    }
    port {
      port        = 80
      target_port = 8080
    }
  }
}

resource "kubernetes_ingress_v1" "echoserver" {
  count = var.create_echo_server ? 1 : 0

  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace.default.metadata.0.name
    annotations = {
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/tags"        = join(",", [for k, v in var.tags : "${k}=${v}"])
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          backend {
            service {
              name = "echoserver"
              port {
                number = 80
              }
            }
          }

          path = "/echo/*"
        }
      }
    }
  }
}

resource "aws_security_group" "echoserver" {
  name        = local.project
  description = "Connect to ${local.project} cluster NLB"
  vpc_id      = var.vpc.id
}

resource "kubernetes_manifest" "echoserver" {
  manifest = {
    apiVersion = "apigatewayv2.services.k8s.aws/v1alpha1"
    kind       = "VPCLink"
    metadata = {
      name      = local.project
      namespace = "kube-system"
    }
    spec = {
      name = local.project
      securityGroupIDs = [aws_security_group.echoserver.id]
      subnetIDs = [var.vpc.private_subnets_ids.2]
    }
  }
}
