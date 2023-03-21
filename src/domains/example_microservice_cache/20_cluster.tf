resource "aws_elasticache_subnet_group" "this" {
  name       = local.project
  subnet_ids = aws_subnet.this[*].id
}

resource "aws_security_group" "redis" {
  name   = "${local.project}-elasticache-redis"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "redis_ingress" {
  type                     = "ingress"
  from_port                = "6379"
  to_port                  = "6379"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.allow_cache_connection.id
  security_group_id        = aws_security_group.redis.id
}

resource "aws_elasticache_replication_group" "this" {
  engine                     = "redis"
  description                = "${local.project}-redis"
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = [aws_security_group.redis.id]
  replication_group_id       = local.project
  num_cache_clusters         = var.cluster_replicas
  node_type                  = var.node_type
  engine_version             = var.redis_version
  maintenance_window         = var.maintenance_window
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  automatic_failover_enabled = var.enable_multiaz
  at_rest_encryption_enabled = var.enable_encryption
  transit_encryption_enabled = var.enable_encryption
  apply_immediately          = var.apply_immediately
}
