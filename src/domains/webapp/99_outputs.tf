output "distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.cloudfront_distribution_domain_name
}

output "distribution_id" {
  description = "CloudFront distribution id"
  value       = module.cloudfront.cloudfront_distribution_id
}
