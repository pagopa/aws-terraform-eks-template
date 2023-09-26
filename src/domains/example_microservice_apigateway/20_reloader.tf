resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = var.reloader.chart_version
  namespace  = kubernetes_namespace.this.id

  set {
    name  = "reloader.deployment.image.name"
    value = var.reloader.image_name
  }

  set {
    name  = "reloader.deployment.image.tag"
    value = var.reloader.image_tag
  }

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}

