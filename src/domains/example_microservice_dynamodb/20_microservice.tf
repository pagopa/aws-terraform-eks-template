module "database_reader" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${local.project}-dynamodb"

  role_policy_arns = {
    policy = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  }

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${var.app_name}"]
    }
  }
}

resource "kubernetes_service_account" "database_reader" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.database_reader.iam_role_arn
    }
  }
}

resource "kubernetes_pod" "awscli" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }

  spec {
    restart_policy       = "Never"
    service_account_name = kubernetes_service_account.database_reader.metadata[0].name

    container {
      image = "amazon/aws-cli"
      name  = var.app_name
      args  = ["dynamodb", "get-item", "--table-name", aws_dynamodb_table.entries.name, "--key", "Type={S=counter}"]

      env {
        name  = "AWS_REGION"
        value = "eu-south-1"
      }
    }
  }
}
