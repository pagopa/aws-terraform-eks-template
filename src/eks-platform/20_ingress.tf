module "load_balancer_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name_prefix                       = "${local.project}-ingress-"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "${var.ingress.namespace}:aws-load-balancer-controller"
      ]
    }
  }
}

module "aws_load_balancer_controller" {
  source  = "terraform-module/release/helm"
  version = "2.8.0"

  repository = "https://aws.github.io/eks-charts"
  namespace  = kubernetes_namespace.ingress.metadata.0.name
  app = {
    name          = "aws-load-balancer-controller"
    chart         = "aws-load-balancer-controller"
    version       = var.ingress.helm_version
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
      value = var.ingress.replica_count
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = module.load_balancer_irsa_role.iam_role_arn
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = var.vpc.id
    }
  ]
}

# resource "aws_api_gateway_vpc_link" "this" {
#   name        = local.project
#   description = "${local.project} link to cluster NLB"
#   target_arns = [module.nlb.lb_arn]
# }

