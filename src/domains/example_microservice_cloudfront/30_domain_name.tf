resource "aws_route53_record" "cdn_env_eks_pagopa_it" {
  zone_id = var.hosted_zone_id
  name    = var.alias
  type    = "A"

  alias {
    name                   = module.cloudfront.cloudfront_distribution_domain_name
    zone_id                = module.cloudfront.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = true
  }
}
