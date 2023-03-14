resource "kubernetes_namespace" "this" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value
  }

  depends_on = [
    module.eks
  ]
}
