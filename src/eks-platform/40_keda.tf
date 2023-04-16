resource "helm_release" "keda" {
  name       = "keda"
  chart      = "keda"
  repository = "https://kedacore.github.io/charts"
  version    = var.keda.helm_version
  namespace  = var.keda.namespace

  set {
    name  = "operator.name"
    value = "keda-operator"
  }

  set {
    name  = "podSecurityContext.fsGroup"
    value = 1001
  }

  set {
    name  = "securityContext.runAsGroup"
    value = 1001
  }

  set {
    name  = "securityContext.runAsUser"
    value = 1001
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "keda-operator"
  }

  depends_on = [kubernetes_namespace.this]
}
