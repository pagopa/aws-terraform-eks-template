module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 3.2.0"

  aliases = [var.alias]

  viewer_certificate = {
    acm_certificate_arn      = module.acm.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  comment             = local.project
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = var.price_class
  retain_on_delete    = false
  wait_for_deployment = false

  create_monitoring_subscription = var.create_monitoring_subscription

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to ${module.s3_hosting.s3_bucket_id} S3 bucket"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    s3_oac = {
      domain_name           = module.s3_hosting.s3_bucket_bucket_regional_domain_name
      origin_access_control = "s3_oac"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_oac"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  default_root_object = var.default_root_object

  custom_error_response = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/${var.default_root_object}"
    },
    {
      error_code         = 403
      response_code      = 200
      response_page_path = "/${var.default_root_object}"
    }
  ]

  geo_restriction = {
    restriction_type = var.geo_restriction.type
    locations        = var.geo_restriction.locations
  }
}
