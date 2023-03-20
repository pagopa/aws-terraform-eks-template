resource "kubernetes_pod" "awscli" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
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
        name = "PGPASSWORD"
        value = module.aurora_postgresql_v2.cluster_master_password
      }
    }
  }
}
