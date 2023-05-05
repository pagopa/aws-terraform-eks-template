locals {
  nat_gateway_count = var.enable_single_nat_gateway ? 1 : length(var.azs)
}
