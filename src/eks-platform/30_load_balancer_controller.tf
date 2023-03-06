module "load_balancer_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${local.project}-load-balancer-controller"

  attach_load_balancer_controller_targetgroup_binding_only_policy = true

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "${var.aws_load_balancer_controller.namespace}:${var.aws_load_balancer_controller.service_account_name}"
      ]
    }
  }
}

module "aws_load_balancer_controller" {
  source  = "terraform-module/release/helm"
  version = "2.8.0"

  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"
  app = {
    name          = "aws-load-balancer-controller"
    chart         = "aws-load-balancer-controller"
    version       = var.aws_load_balancer_controller.helm_version
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
      value = var.aws_load_balancer_controller.replica_count
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = var.aws_load_balancer_controller.service_account_name
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
