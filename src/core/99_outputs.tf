output "vpc_id" {
  description = "Id of the current VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets_ids" {
  description = "Id list of the public subnets"
  value       = module.vpc.public_subnets
}

output "nat_ids" {
  description = "Id list of the nat gatways subnets"
  value       = aws_nat_gateway.this[*].id
}
