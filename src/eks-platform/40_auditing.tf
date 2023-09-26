locals {
  create_bucket = var.sentinel_bucket_arn == null
}

resource "aws_s3_bucket" "audit_export" {
  count  = local.create_bucket ? 1 : 0
  bucket = "${local.project}-eks-audit-for-sentinel"
}

module "audit_exporter_artifacts" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.7.0"

  bucket_prefix = "${local.project}-eks-audit-exporter-artifacts"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = true
}

resource "aws_security_group" "audit_exporter" {
  name_prefix = "${local.project}-"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_policy" "audit_exporter_execute" {
  name        = "${local.project}-audit-exporter-execute"
  description = "Grants permission to export logs from CloudWatch to S3."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowImportLogs"
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject"],
        Resource = local.create_bucket ? "arn:aws:s3:::${aws_s3_bucket.audit_export[0].bucket}/*" : "${var.sentinel_bucket_arn}/*"
      }
    ]
  })
}

module "audit_exporter" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 5.0.0"

  function_name = "${local.project}-eks-audit-exporter"
  description   = "Export EKS audit logs from CloudWatch and uploads them to S3"
  handler       = "app.lambda_handler"
  runtime       = "python3.10"
  timeout       = 5
  architectures = ["x86_64"]

  source_path = {
    path             = "${path.module}/assets/audit_exporter_lambda"
    pip_requirements = true
    patterns         = ["!.venv/.*"]
  }

  build_in_docker           = var.build_lambdas_in_docker
  docker_additional_options = ["--platform", "linux/amd64"]

  store_on_s3 = true
  s3_bucket   = module.audit_exporter_artifacts.s3_bucket_id

  vpc_subnet_ids         = aws_subnet.this[*].id
  vpc_security_group_ids = [aws_security_group.audit_exporter.id]
  attach_network_policy  = true

  attach_policy = true
  policy        = aws_iam_policy.audit_exporter_execute.arn

  environment_variables = {
    BUCKET_NAME = local.create_bucket ? aws_s3_bucket.audit_export[0].bucket : split(":", var.sentinel_bucket_arn)[5]
  }
}

data "aws_cloudwatch_log_group" "eks" {
  name = "/aws/eks/${module.eks.cluster_name}/cluster"

  depends_on = [module.eks]
}

resource "aws_lambda_permission" "audit_exporter" {
  action        = "lambda:InvokeFunction"
  function_name = module.audit_exporter.lambda_function_name
  principal     = "logs.${var.aws_region}.amazonaws.com"
  source_arn    = "${data.aws_cloudwatch_log_group.eks.arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "audit_exporter" {
  name            = "${local.project}-eks-audit"
  log_group_name  = data.aws_cloudwatch_log_group.eks.name
  filter_pattern  = "{($.apiVersion = \"audit.k8s.io/v1\") && ($.kind = \"Event\")}"
  destination_arn = module.audit_exporter.lambda_function_arn
}
