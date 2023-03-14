output "vpc_id" {
  description = "Id of the current VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets_ids" {
  description = "Id list of the private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets_ids" {
  description = "Id list of the public subnets"
  value       = module.vpc.public_subnets
}
