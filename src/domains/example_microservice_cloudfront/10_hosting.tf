module "s3_hosting" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.7.0"

  bucket_prefix = "${local.project}-hosting-"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = true
}
