resource "aws_security_group" "allow_db_connection" {
  name        = "${local.project}-allow-db-connection"
  description = "Allow connection to database"
  vpc_id      = var.vpc_id
}
