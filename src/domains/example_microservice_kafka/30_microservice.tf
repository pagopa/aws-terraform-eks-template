resource "kubernetes_pod" "kcat" {
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
      image = "edenhill/kcat:1.7.1"
      name  = var.app_name
      args = [
        "-b", aws_msk_cluster.this.bootstrap_brokers,
        "-L",
      ]
    }
  }
}

resource "kubernetes_manifest" "allow_db_connection" {
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
          aws_security_group.allow_kafka_connection.id,
          var.eks_security_group_id,
        ]
      }
    }
  }
}
