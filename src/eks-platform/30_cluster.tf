module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15.3"

  cluster_name                   = local.project
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = var.enable_public_endpoint

  cluster_enabled_log_types = ["api", "authenticator", "audit", "scheduler", "controllerManager"]

  cluster_addons = {
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
    }
    vpc-cni = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"

      configuration_values = jsonencode({
        env = {
          ENABLE_POD_ENI = "true"
        }
      })
    }
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"

      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.this[*].id
  # control_plane_subnet_ids = var.vpc.intra_subnets_ids

  create_cluster_security_group = false
  create_node_security_group    = false

  fargate_profiles = merge(
    { for i in range(3) :
      "${local.project}-${element(split("-", var.azs[i]), 2)}" => {
        selectors  = [{ namespace = "*" }]
        subnet_ids = [element(aws_subnet.this, i).id]
      }
    },
    { for i in range(3) :
      "kube-system-${element(split("-", var.azs[i]), 2)}" => {
        selectors  = [{ namespace = "kube-system" }]
        subnet_ids = [element(aws_subnet.this, i).id]
      }
    }
  )
}

resource "aws_security_group_rule" "allow_lb_connections" {
  security_group_id = module.eks.cluster_primary_security_group_id
  description       = "Allow access from ALB"

  type                     = "ingress"
  from_port                = 1024
  to_port                  = 65535
  protocol                 = "all"
  source_security_group_id = module.alb.security_group_id
}

resource "aws_security_group_rule" "allow_ecs_github_runners" {
  count = var.github_runners_sg_id == null ? 0 : 1

  security_group_id = module.eks.cluster_primary_security_group_id
  description       = "Allow access from ECS GH runners cluster"

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  source_security_group_id = var.github_runners_sg_id
}
