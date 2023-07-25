resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }

  depends_on = [module.eks]
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

resource "kubectl_manifest" "metrics_server_sg" {
  yaml_body = yamlencode({
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
  })
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.prometheus.chart_version
  namespace  = kubernetes_namespace.monitoring.id

  set {
    name  = "server.global.scrape_interval"
    value = "5s"
  }

  set {
    name  = "server.global.evaluation_interval"
    value = "5s"
  }

  set {
    name  = "server.global.scrape_timeout"
    value = "4s"
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
    value = "3000Mi"
  }

  set {
    name  = "server.resources.limits.cpu"
    value = "1500m"
  }

  set {
    name  = "server.resources.requests.memory"
    value = "2000Mi"
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
