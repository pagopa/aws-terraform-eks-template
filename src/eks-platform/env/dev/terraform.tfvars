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

prometheus = {
  chart_version = "15.12.0"
  configmap_reload_prometheus = {
    image_name = "jimmidyson/configmap-reload"
    image_tag  = "v0.5.0@sha256:91467ba755a0c41199a63fe80a2c321c06edc4d3affb4f0ab6b3d20a49ed88d1"
  }
  node_exporter = {
    image_name = "quay.io/prometheus/node-exporter"
    image_tag  = "v1.3.1@sha256:f2269e73124dd0f60a7d19a2ce1264d33d08a985aed0ee6b0b89d0be470592cd"
  }
  server = {
    image_name = "quay.io/prometheus/prometheus"
    image_tag  = "v2.36.2@sha256:df0cd5887887ec393c1934c36c1977b69ef3693611932c3ddeae8b7a412059b9"
  }
  pushgateway = {
    image_name = "prom/pushgateway"
    image_tag  = "v1.4.3@sha256:9e4e2396009751f1dc66ebb2b59e07d5abb009eb26d637eb0cf89b9a3738f146"
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
