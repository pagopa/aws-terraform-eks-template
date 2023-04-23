resource "aws_iam_role" "fargate_profile" {
  name_prefix = "${local.project}-"
  description = "Fargate profile IAM role"

  force_detach_policies = true
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_profile" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_profile.name
}

resource "aws_eks_fargate_profile" "this" {
  for_each = toset(var.cluster_subnet_ids)

  cluster_name           = var.cluster_name
  fargate_profile_name   = "${local.project}-${each.value}"
  pod_execution_role_arn = aws_iam_role.fargate_profile.arn
  subnet_ids             = [each.value]

  selector {
    namespace = var.namespace
  }

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}
