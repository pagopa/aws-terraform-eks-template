output "distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.cloudfront_distribution_domain_name
}

output "distribution_id" {
  description = "CloudFront distribution id"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "hosting_bucket_name" {
  description = "S3 hosting bucket name"
  value       = module.s3_hosting.s3_bucket_id
}
