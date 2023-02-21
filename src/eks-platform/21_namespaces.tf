resource "kubernetes_namespace" "default" {
  metadata {
    name = var.app_name
  }
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = var.ingress.namespace
  }
}
