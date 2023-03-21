resource "kubernetes_pod" "redis" {
  metadata {
    name      = var.app_name
    namespace = var.namespace

    labels = {
      app = var.app_name
    }
  }

  spec {
    restart_policy = "Never"

    container {
      image   = "redis"
      name    = var.app_name
      command = ["redis-cli"]
      args = [
        "-h", aws_elasticache_replication_group.this.primary_endpoint_address,
        "PING",
      ]
    }
  }
}

resource "kubernetes_manifest" "allow_cache_connection" {
  manifest = {
    apiVersion = "vpcresources.k8s.aws/v1beta1"
    kind       = "SecurityGroupPolicy"

    metadata = {
      name      = var.app_name
      namespace = var.namespace
    }

    spec = {
      podSelector = {
        matchLabels = {
          app = var.app_name
        }
      }

      securityGroups = {
        groupIds = [
          aws_security_group.allow_cache_connection.id,
          var.cluster_security_group_id,
        ]
      }
    }
  }
}
