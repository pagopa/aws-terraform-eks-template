resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  chart      = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  version    = var.metrics_server.chart_version
  namespace  = var.metrics_server.namespace

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
      namespace = var.metrics_server.namespace
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
