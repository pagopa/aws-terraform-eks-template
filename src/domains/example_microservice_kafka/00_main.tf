terraform {
  required_version = ">= 1.3.1"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.53.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.17.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "arn:aws:eks:eu-south-1:794703684555:cluster/dvopla-d"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "arn:aws:eks:eu-south-1:794703684555:cluster/dvopla-d"
  }
}

locals {
  project = format("%s-%s", var.app_name, var.env_short)
}

data "aws_caller_identity" "current" {}
