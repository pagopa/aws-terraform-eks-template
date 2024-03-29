resource "kubernetes_job" "psql" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }

  spec {
    ttl_seconds_after_finished = 60

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        restart_policy = "Never"

        container {
          image   = "postgres"
          name    = var.app_name
          command = ["psql"]
          args = [
            "-h", module.aurora_postgresql_v2.cluster_endpoint,
            "-d", module.aurora_postgresql_v2.cluster_database_name,
            "-U", module.aurora_postgresql_v2.cluster_master_username,
            "-c", "SELECT * FROM information_schema.tables;",
          ]

          env {
            name  = "PGPASSWORD"
            value = module.aurora_postgresql_v2.cluster_master_password
          }
        }
      }
    }
  }

  timeouts {
    create = "2m"
    update = "2m"
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
          aws_security_group.allow_db_connection.id,
          var.eks_security_group_id,
        ]
      }
    }
  }
}
