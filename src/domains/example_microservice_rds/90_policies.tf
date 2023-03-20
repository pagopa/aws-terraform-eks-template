resource "aws_iam_policy" "backup_access" {
  name = "${local.project}-backup-access"
  policy = templatefile("${path.module}/assets/custom_policies/backup_access.json.tftpl",
    {
      cluster_vault_name   = aws_backup_vault.cluster.name
      cluster_id           = module.aurora_postgresql_v2.cluster_id
      cluster_instance_ids = [for i in module.aurora_postgresql_v2.cluster_instances : i.id]
  })
}

