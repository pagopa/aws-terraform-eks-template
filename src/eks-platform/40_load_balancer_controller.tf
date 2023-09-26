module "load_balancer_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${local.project}-load-balancer-controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "${var.aws_load_balancer_controller.namespace}:${var.aws_load_balancer_controller.service_account_name}"
      ]
    }
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  version    = var.aws_load_balancer_controller.chart_version
  repository = "https://aws.github.io/eks-charts"
  namespace  = var.aws_load_balancer_controller.namespace

  set {
    name  = "image.aws_load_balancer_controller.repository"
    value = var.aws_load_balancer_controller.image_name
  }

  set {
    name  = "image.aws_load_balancer_controller.tag"
    value = var.aws_load_balancer_controller.image_tag
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "replicaCount"
    value = var.aws_load_balancer_controller.replica_count
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = var.aws_load_balancer_controller.service_account_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.load_balancer_irsa_role.iam_role_arn
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }
}
