resource "aws_subnet" "this" {
  count = length(var.subnets_cidr)

  vpc_id               = var.vpc_id
  cidr_block           = var.subnets_cidr[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
}

resource "aws_route_table" "this" {
  count = length(var.nat_gateway_ids)

  vpc_id = var.vpc_id
}

resource "aws_route" "this" {
  count = length(var.nat_gateway_ids)

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.this[count.index].id
  nat_gateway_id         = var.nat_gateway_ids[count.index]

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "this" {
  count = length(aws_subnet.this)

  subnet_id = aws_subnet.this[count.index].id
  route_table_id = element(
    aws_route_table.this[*].id,
    length(var.nat_gateway_ids) == 1 ? 0 : count.index
  )
}

