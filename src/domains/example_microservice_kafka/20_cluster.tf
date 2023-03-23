resource "aws_security_group" "kafka" {
  name   = "${local.project}-msk"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "kafka_ingress_plain" {
  for_each = toset(["2181", "2182", "9092", "9094", "9096", "9098", "9194", "9196", "9198"])

  type                     = "ingress"
  from_port                = each.value
  to_port                  = each.value
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.allow_kafka_connection.id
  security_group_id        = aws_security_group.kafka.id
}

# Not available on eu-south-1
# resource "aws_msk_serverless_cluster" "this" {
#   cluster_name = local.project
#
#   vpc_config {
#     subnet_ids         = aws_subnet.this[*].id
#     security_group_ids = [aws_security_group.kafka.id]
#   }
#
#   client_authentication {
#     sasl {
#       iam {
#         enabled = true
#       }
#     }
#   }
# }

resource "aws_msk_cluster" "this" {
  cluster_name           = local.project
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_replicas

  broker_node_group_info {
    instance_type   = var.broker_type
    client_subnets  = aws_subnet.this[*].id
    security_groups = [aws_security_group.kafka.id]

    storage_info {
      ebs_storage_info {
        volume_size = var.broker_storage
      }
    }
  }

  client_authentication {
    unauthenticated = true

    sasl {
      iam   = false
      scram = false
    }

    tls {}
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }

}
