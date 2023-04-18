resource "aws_iam_role" "keda" {
  name_prefix = "keda-"
  description = "Fargate profile IAM role"

  force_detach_policies = true
  assume_role_policy    = jsonencode({
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

resource "aws_iam_role_policy_attachment" "keda" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.keda.name
}

resource "aws_eks_fargate_profile" "keda" {
  for_each = toset(aws_subnet.this[*].id)

  cluster_name           = module.eks.cluster_name
  fargate_profile_name   = "keda-${each.value}"
  pod_execution_role_arn = aws_iam_role.keda.arn
  subnet_ids             = [each.value]

  selector {
    namespace = var.keda.namespace
  }

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "kubernetes_namespace" "keda" {
  metadata {
    name = var.keda.namespace
  }
}

resource "helm_release" "keda" {
  name       = "keda"
  chart      = "keda"
  repository = "https://kedacore.github.io/charts"
  version    = var.keda.helm_version
  namespace  = var.keda.namespace

  set {
    name  = "operator.name"
    value = "keda-operator"
  }

  set {
    name  = "podSecurityContext.fsGroup"
    value = 1001
  }

  set {
    name  = "securityContext.runAsGroup"
    value = 1001
  }

  set {
    name  = "securityContext.runAsUser"
    value = 1001
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "keda-operator"
  }

  depends_on = [kubernetes_namespace.keda]
}
