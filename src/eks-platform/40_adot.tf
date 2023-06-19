resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  version    = var.cert_manager.chart_version
  namespace  = var.cert_manager.namespace

  set {
    name  = "webhook.securePort"
    value = 10260
  }

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "image.repository"
    value = var.cert_manager.controller.image_name
  }

  set {
    name  = "image.tag"
    value = var.cert_manager.controller.image_tag
  }

  set {
    name  = "webhook.image.repository"
    value = var.cert_manager.webhook.image_name
  }

  set {
    name  = "webhook.image.tag"
    value = var.cert_manager.webhook.image_tag
  }

  set {
    name  = "cainjector.image.repository"
    value = var.cert_manager.cainjector.image_name
  }

  set {
    name  = "cainjector.image.tag"
    value = var.cert_manager.cainjector.image_tag
  }

  set {
    name  = "startupapicheck.image.repository"
    value = var.cert_manager.startupapicheck.image_name
  }

  set {
    name  = "startupapicheck.image.tag"
    value = var.cert_manager.startupapicheck.image_tag
  }

  set {
    name  = "acmesolver.image.repository"
    value = var.cert_manager.acmesolver.image_name
  }

  set {
    name  = "acmesolver.image.tag"
    value = var.cert_manager.acmesolver.image_tag
  }
}

module "adot_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${local.project}-adot"

  role_policy_arns = {
    cloud_watch = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    xray        = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
    # prometheus  = "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess"
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["opentelemetry-operator-system:aws-otel-collector"]
    }
  }
}

data "aws_eks_addon_version" "adot" {
  addon_name         = "adot"
  kubernetes_version = var.cluster_version
  most_recent        = true
}

resource "aws_eks_addon" "adot" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "adot"
  addon_version = data.aws_eks_addon_version.adot.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  configuration_values = jsonencode({
    collector = {
      cloudwatch = {
        enabled = true
      }
      xray = {
        enabled = true
      }
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.adot_irsa_role.iam_role_arn
        }
      }
      resources = {
        requests = {
          cpu    = "1000m"
          memory = "2Gi"
        }

        limits = {
          cpu    = "1500m"
          memory = "4Gi"
        }
      }
    }
  })

  depends_on = [helm_release.cert_manager]
}
