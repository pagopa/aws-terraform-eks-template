module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.3.2"

  providers = {
    aws = aws.global
  }

  domain_name = var.alias
  zone_id     = var.hosted_zone_id
}

