resource "kubernetes_deployment" "echoserver" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          image = "k8s.gcr.io/echoserver:1.10"
          name  = var.app_name

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "echoserver" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_name
    }
    port {
      port        = 80
      target_port = 8080
    }
  }
}

resource "kubernetes_ingress_v1" "echoserver" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
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
              name = var.app_name
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
