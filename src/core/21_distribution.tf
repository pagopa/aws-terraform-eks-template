module "cloudfront_log" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.7.0"

  count = var.cf_create_log_bucket ? 1 : 0

  bucket_prefix = "${local.project}-cflog-"
  force_destroy = true
  acl           = null
  grant = [
    {
      type       = "CanonicalUser"
      permission = "FULL_CONTROL"
      id         = data.aws_canonical_user_id.current.id
    },
    {
      type       = "CanonicalUser"
      permission = "FULL_CONTROL"
      id         = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
    }
  ]
}

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 3.2.0"

  aliases = var.cf_aliases

  viewer_certificate = {
    cloudfront_default_certificate = var.cf_certificate_arn == null ? true : null
    acm_certificate_arn            = var.cf_certificate_arn
    minimum_protocol_version       = var.cf_certificate_arn == null ? "TLSv1" : "TLSv1.2_2021"
    ssl_support_method             = var.cf_certificate_arn == null ? null : "sni-only"
  }

  comment             = local.project
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = var.cf_price_class
  retain_on_delete    = false
  wait_for_deployment = false

  create_monitoring_subscription = var.cf_create_monitoring_subscription

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to ${module.s3_hosting.s3_bucket_id} S3 bucket"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  logging_config = anytrue([var.cf_log_bucket_domain_name, length(module.cloudfront_log) > 0]) ? {
    bucket = coalesce(var.cf_log_bucket_domain_name, module.cloudfront_log[0].s3_bucket_bucket_domain_name)
    prefix = local.project
  } : {}

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

  default_root_object = var.cf_default_root_object

  custom_error_response = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/${var.cf_default_root_object}"
    },
    {
      error_code         = 403
      response_code      = 200
      response_page_path = "/${var.cf_default_root_object}"
    }
  ]

  geo_restriction = {
    restriction_type = var.cf_geo_restriction.type
    locations        = var.cf_geo_restriction.locations
  }
}
