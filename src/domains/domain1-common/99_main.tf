terraform {
  required_version = "~> 1.3.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}

locals {
  project = format("%s-%s", var.prefix, var.env_short)
}

data "aws_caller_identity" "current" {}
