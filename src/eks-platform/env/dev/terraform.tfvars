env_short   = "d"
environment = "dev"
app_name    = "dvopla"

vpc_id                 = "vpc-07e680d083d85f636"
nat_gateway_ids        = ["nat-00513a086ac6d89dd"]
enable_public_endpoint = true

aws_load_balancer_controller = {
  chart_version        = "1.4.7"
  replica_count        = 1
  namespace            = "kube-system"
  service_account_name = "aws-load-balancer-controller"
  image_name           = "public.ecr.aws/eks/aws-load-balancer-controller"
  image_tag            = "v2.4.6@sha256:b2460dd8db8962455857e8e90ddbaa8b96bc567bcb3e815342c91e0dd921ece1"
}

keda = {
  chart_version = "2.10.0"
  namespace     = "keda"

  keda = {
    image_name = "ghcr.io/kedacore/keda"
    image_tag  = "2.10.0@sha256:c80b0c291b1f350c6d4c2401718812d39c3d4ed96eb556f36eb086562ab9e8d4"
  }

  metrics_api_server = {
    image_name = "ghcr.io/kedacore/keda-metrics-apiserver"
    image_tag  = "2.10.0@sha256:9e2d30eb447bf5856e992f218de3004927520abd148c32f01c851b2250f07023"
  }

  webhooks = {
    image_name = "ghcr.io/kedacore/keda-admission-webhooks"
    image_tag  = "2.10.0@sha256:8c062db679a95626966f29f9ad26c179acea91105b6258da897b5ed930461267"
  }
}

metrics_server = {
  chart_version = "3.10.0"
  namespace     = "kube-system"
  image_name    = "registry.k8s.io/metrics-server/metrics-server"
  image_tag     = "v0.6.3@sha256:c60778fa1c44d0c5a0c4530ebe83f9243ee6fc02f4c3dc59226c201931350b10"
}

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
