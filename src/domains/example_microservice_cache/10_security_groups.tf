resource "aws_security_group" "allow_cache_connection" {
  name        = "${local.project}-allow-cache-connection"
  description = "Allow connection to cache"
  vpc_id      = var.vpc_id
}
