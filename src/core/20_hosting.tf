module "s3_hosting" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.7.0"

  bucket_prefix = "${local.project}-hosting-"
  force_destroy = true
}
