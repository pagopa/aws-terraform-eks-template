resource "aws_iam_policy" "additional" {
  name = "${local.project}-fargate-additional"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = local.project
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = false

  cluster_addons = {
    kube-proxy = {}
    vpc-cni    = {}
    coredns = {
      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
  }

  vpc_id                   = var.vpc.id
  subnet_ids               = var.vpc.private_subnets_ids
  control_plane_subnet_ids = var.vpc.intra_subnets_ids

  # Fargate profiles use the cluster primary security group so these are not utilized
  create_cluster_security_group = false
  create_node_security_group    = false

  fargate_profile_defaults = {
    iam_role_additional_policies = {
      additional = aws_iam_policy.additional.arn
    }
  }

  fargate_profiles = merge(
    {
      default = {
        name = var.app_name
        selectors = [
          {
            namespace = var.app_name
          }
        ]

        # Using specific subnets instead of the subnets supplied for the cluster itself
        # subnet_ids = [var.vpc.private_subnets_ids[1]]

        timeouts = {
          create = "20m"
          delete = "20m"
        }
      }
    },
    { for i in range(3) :
      "kube-system-${element(split("-", var.azs[i]), 2)}" => {
        selectors = [
          { namespace = "kube-system" }
        ]

        subnet_ids = [element(var.vpc.private_subnets_ids, i)]
      }
    }
  )
}
