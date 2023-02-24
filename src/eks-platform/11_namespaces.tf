resource "kubernetes_namespace" "default" {
  metadata {
    name = var.app_name
  }
}
