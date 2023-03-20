module "aurora_postgresql_v2" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "v7.7.0"

  name              = "${local.project}-postgresqlv2"
  database_name     = regex("[[:alnum:]]+", var.app_name)
  engine            = data.aws_rds_engine_version.postgresql.engine
  engine_version    = data.aws_rds_engine_version.postgresql.version
  engine_mode       = "provisioned"
  storage_encrypted = true

  vpc_id                  = var.vpc_id
  subnets                 = aws_subnet.this[*].id
  create_security_group   = true
  allowed_security_groups = [aws_security_group.allow_db_connection.id]

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = {
    min_capacity = var.cluster_min_capacity
    max_capacity = var.cluster_max_capacity
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
  }
}

resource "aws_backup_plan" "cluster" {
  name = "${local.project}-cluster-backup-plan"
  rule {
    rule_name         = "every-hour"
    target_vault_name = aws_backup_vault.cluster.name
    schedule          = "cron(59 * * * ? *)"
  }
}

resource "aws_backup_vault" "cluster" {
  name = "${local.project}-cluster"
}

resource "aws_backup_selection" "cluster" {
  name         = "${local.project}-cluster-backup-selection"
  plan_id      = aws_backup_plan.cluster.id
  iam_role_arn = aws_iam_role.backup_executor.arn
  resources    = [module.aurora_postgresql_v2.cluster_arn]
}
