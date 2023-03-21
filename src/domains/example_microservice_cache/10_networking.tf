resource "aws_subnet" "this" {
  count = length(var.subnets_cidr)

  vpc_id               = var.vpc_id
  cidr_block           = var.subnets_cidr[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
}
