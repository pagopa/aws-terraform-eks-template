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
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "terraform_states" {
  bucket_prefix = "terraform-backend-"

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(var.tags, {
    name = "S3 Remote Terraform State Store"
  })
}

resource "aws_s3_bucket_acl" "terraform_states" {
  bucket = aws_s3_bucket.terraform_states.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "terraform_states" {
  bucket                  = aws_s3_bucket.terraform_states.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "terraform_states" {
  bucket = aws_s3_bucket.terraform_states.id
  versioning_configuration {
    status = "Enabled"
  }
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_states" {
  bucket = aws_s3_bucket.terraform_states.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

#tfsec:ignore:aws-dynamodb-enable-at-rest-encryption
#tfsec:ignore:aws-dynamodb-enable-recovery
#tfsec:ignore:aws-dynamodb-table-customer-key
resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 4
  write_capacity = 4

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.tags, {
    name = "DynamoDB Terraform State Lock Table"
  })

}

data "aws_iam_policy" "admin_access" {
  name = "AdministratorAccess"
}

data "aws_iam_policy" "read_only_access" {
  name = "ReadOnlyAccess"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "githubiac" {
  for_each = toset(["Admin", "ReadOnly", "ECSRunner"])

  name        = "GitHubActionIAC${each.value}"
  description = "Role assumed by GitHub to manage infrastructure"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_repository}:*"
          },
          "ForAllValues:StringEquals" = {
            "token.actions.githubusercontent.com:iss" : "https://token.actions.githubusercontent.com",
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "githubiac_admin" {
  role       = aws_iam_role.githubiac["Admin"].name
  policy_arn = data.aws_iam_policy.admin_access.arn
}

resource "aws_iam_role_policy_attachment" "githubiac_ro" {
  role       = aws_iam_role.githubiac["ReadOnly"].name
  policy_arn = data.aws_iam_policy.read_only_access.arn
}

resource "aws_iam_role_policy" "githubiac_ecsrunner" {
  role = aws_iam_role.githubiac["ECSRunner"].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:RunTask",
          "ecs:StopTask",
          "iam:PassRole" # TODO restrict this one
        ]
        Resource = "*"
      }
    ]
  })
}
