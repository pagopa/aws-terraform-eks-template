data "aws_vpc_endpoint_service" "dynamodb" {
  service = "dynamodb"
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = module.vpc.vpc_id
  service_name = data.aws_vpc_endpoint_service.dynamodb.service_name
}

resource "aws_vpc_endpoint_route_table_association" "intra_dynamodb" {
  for_each = toset(module.vpc.intra_route_table_ids)

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = each.value
}

resource "aws_vpc_endpoint_route_table_association" "private_dynamodb" {
  for_each = toset(module.vpc.private_route_table_ids)

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = each.value
}

resource "aws_vpc_endpoint_route_table_association" "public_dynamodb" {
  for_each = tomap({ for k, v in module.vpc.public_route_table_ids : k => v })

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
  route_table_id  = each.value
}
