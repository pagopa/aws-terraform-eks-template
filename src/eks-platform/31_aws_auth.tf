resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(concat(
      [for name, profile in module.eks.fargate_profiles : {
        groups   = ["system:bootstrappers", "system:nodes", "system:node-proxier"]
        rolearn  = profile.iam_role_arn
        username = "system:node:{{SessionName}}"
      }],
      [for auth in var.eks_auth : {
          groups   = auth.groups
          rolearn  = auth.role_arn
          username = "system:node:{{SessionName}}"
          noDuplicateARNs = true
      }]
    ))
  }
}
