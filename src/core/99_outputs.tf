output "vpc_id" {
  description = "Id of the current VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets_ids" {
  description = "Id list of the private subnets"
  value       = module.vpc.private_subnets
}

output "intra_subnets_ids" {
  description = "Id list of the intra subnets"
  value       = module.vpc.intra_subnets
}

output "public_subnets_ids" {
  description = "Id list of the public subnets"
  value       = module.vpc.public_subnets
}

output "distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.cloudfront_distribution_domain_name
}

output "distribution_id" {
  description = "CloudFront distribution id"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "api_gateway_id" {
  description = "API Gateway id"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_stage_domain_name" {
  description = "Domain name of the API main stage"
  value       = aws_api_gateway_stage.this.invoke_url
}
