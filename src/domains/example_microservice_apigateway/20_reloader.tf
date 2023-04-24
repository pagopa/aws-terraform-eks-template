resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.22"
  namespace  = kubernetes_namespace.this.id

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}

