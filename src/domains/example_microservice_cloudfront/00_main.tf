terraform {
  required_version = ">= 1.3.1"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.53.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

provider "aws" {
  alias = "global"

  region = "us-east-1"

  default_tags {
    tags = var.tags
  }
}

locals {
  project = format("%s-%s", var.app_name, var.env_short)
}

data "aws_canonical_user_id" "current" {}
data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

