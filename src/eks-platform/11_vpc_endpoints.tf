module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> v4.0.1"

  vpc_id = var.vpc_id

  endpoints = {
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = aws_route_table.this[*].id
    }

    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = aws_route_table.this[*].id
    }
  }
}
