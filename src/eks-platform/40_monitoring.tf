resource "kubernetes_namespace" "keda" {
  metadata {
    name = "keda"
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
      namespace = kubernetes_namespace.keda.id
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

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  chart      = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  version    = var.metrics_server.chart_version
  namespace  = kubernetes_namespace.monitoring.id

  set {
    name  = "image.repository"
    value = var.metrics_server.image_name
  }

  set {
    name  = "image.tag"
    value = var.metrics_server.image_tag
  }

  set {
    name  = "containerPort"
    value = 4443
  }

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}

resource "kubernetes_manifest" "metrics_server_sg" {
  manifest = {
    apiVersion = "vpcresources.k8s.aws/v1beta1"
    kind       = "SecurityGroupPolicy"

    metadata = {
      name      = "metrics-server"
      namespace = kubernetes_namespace.monitoring.id
    }

    spec = {
      podSelector = {
        matchLabels = {
          "app.kubernetes.io/instance" = "metrics-server"
          "app.kubernetes.io/name"     = "metrics-server"
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

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.prometheus.chart_version
  namespace  = kubernetes_namespace.monitoring.id

  set {
    name  = "server.retention"
    value = "1d"
  }

  set {
    name  = "server.global.scrape_interval"
    value = "30s"
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }

  set {
    name  = "alertmanager.enabled"
    value = false
  }

  set {
    name  = "server.resources.limits.memory"
    value = "1500Mi"
  }

  set {
    name  = "server.resources.limits.cpu"
    value = "1200m"
  }

  set {
    name  = "server.resources.requests.memory"
    value = "250Mi"
  }

  set {
    name  = "server.resources.requests.cpu"
    value = "250m"
  }
}

resource "helm_release" "monitoring_reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = var.reloader.chart_version
  namespace  = kubernetes_namespace.monitoring.id

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
