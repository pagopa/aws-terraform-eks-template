data "aws_iam_policy_document" "apigateway_controller_role_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_arn, "/^(.*provider/)/", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-api-gateway-controller"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_arn, "/^(.*provider/)/", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "apigateway_controller_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["apigateway:*"]
    resources = ["arn:aws:apigateway:*::/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "apigateway_controller" {
  name = "${local.project}-api-gateway-controller"
  path = "/"

  assume_role_policy    = data.aws_iam_policy_document.apigateway_controller_role_assume.json
  force_detach_policies = true
}

resource "aws_iam_policy" "apigateway_controller" {
  name   = "${local.project}-api-gateway-controller-full-access"
  path   = "/"
  policy = data.aws_iam_policy_document.apigateway_controller_full_access.json
}

resource "aws_iam_role_policy_attachment" "apigateway_controller" {
  role       = aws_iam_role.apigateway_controller.name
  policy_arn = aws_iam_policy.apigateway_controller.arn
}

module "aws_api_gateway_controller" {
  source  = "terraform-module/release/helm"
  version = "2.8.0"

  repository = "oci://public.ecr.aws/aws-controllers-k8s"
  namespace  = "kube-system"
  app = {
    name          = "aws-apigatewayv2-controller"
    chart         = "apigatewayv2-chart"
    version       = "v1.0.1"
    wait          = false
    recreate_pods = true
    deploy        = 1
  }

  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "replicaCount"
      value = 1
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-api-gateway-controller"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.apigateway_controller.arn
    },
    {
      name  = "aws.region"
      value = var.aws_region
    }
  ]
}
