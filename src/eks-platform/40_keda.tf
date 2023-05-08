resource "kubernetes_namespace" "keda" {
  metadata {
    name = var.keda.namespace
  }
}

resource "helm_release" "keda" {
  name       = "keda"
  chart      = "keda"
  repository = "https://kedacore.github.io/charts"
  version    = var.keda.chart_version
  namespace  = kubernetes_namespace.keda.id

  set {
    name  = "image.keda.repository"
    value = var.keda.keda.image_name
  }

  set {
    name  = "image.keda.tag"
    value = var.keda.keda.image_tag
  }

  set {
    name  = "image.metrics_api_server.repository"
    value = var.keda.metrics_api_server.image_name
  }

  set {
    name  = "image.metrics_api_server.tag"
    value = var.keda.metrics_api_server.image_tag
  }

  set {
    name  = "image.webhooks.repository"
    value = var.keda.webhooks.image_name
  }

  set {
    name  = "image.webhooks.tag"
    value = var.keda.webhooks.image_tag
  }

  # https://github.com/kedacore/charts/blob/main/keda/values.yaml#L158
  # set {
  #   name  = "serviceAccount.create"
  #   value = false
  # }
}

resource "kubernetes_manifest" "keda_sg" {
  manifest = {
    apiVersion = "vpcresources.k8s.aws/v1beta1"
    kind       = "SecurityGroupPolicy"

    metadata = {
      name      = "keda"
      namespace = var.keda.namespace
    }

    spec = {
      podSelector = {
        matchLabels = {
          "app.kubernetes.io/instance" = "keda"
          "app.kubernetes.io/name"     = "keda-operator"
        }
      }

      securityGroups = {
        groupIds = [
          module.eks.cluster_primary_security_group_id
        ]
      }
    }
  }
}
