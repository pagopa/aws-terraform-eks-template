resource "aws_security_group" "allow_kafka_connection" {
  name        = "${local.project}-allow-kafka-connection"
  description = "Allow connection to MSK"
  vpc_id      = var.vpc_id
}
