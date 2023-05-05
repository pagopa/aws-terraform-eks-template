resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  vpc = true
}

resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = module.vpc.public_subnets[count.index]
}

