env_short   = "d"
environment = "dev"
app_name    = "dvopla"

vpc_id                 = "vpc-07e680d083d85f636"
nat_gateway_ids        = ["nat-0d7267450a50bd589"]
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

reloader = {
  chart_version = "v1.0.22"
  image_name    = "ghcr.io/stakater/reloader"
  image_tag     = "v1.0.22@sha256:c768605b16baa78c075d1bfb2122281201fd2da674ce1d6b410fa929c157693b"
}

cert_manager = {
  chart_version = "1.12.1"
  namespace     = "kube-system"
  controller = {
    image_name = "quay.io/jetstack/cert-manager-controller"
    image_tag  = "v1.12.1@sha256:63a7aa17a1b1ac982ae89eeac0217a505a3bd2a07f65949077efa47ce4f7c86d"
  }
  cainjector = {
    image_name = "quay.io/jetstack/cert-manager-cainjector"
    image_tag  = "v1.12.1@sha256:7c65d8478484155f6f1886b1ed60064e854c7c371b1fddbe220c71e5574e6526"
  }
  webhook = {
    image_name = "quay.io/jetstack/cert-manager-webhook"
    image_tag  = "v1.12.1@sha256:c5644d09c6cfce8059f6b8979fb43f14ca326921a87b571a62ce9ee6dcdf014c"
  }
  startupapicheck = {
    image_name = "quay.io/jetstack/cert-manager-ctl"
    image_tag  = "v1.12.1@sha256:a11327595e62843e0248a9052ea94b47f92eac8fb3b373b3134138e6380886f5"
  }
  acmesolver = {
    image_name = "quay.io/jetstack/cert-manager-acmesolver"
    image_tag  = "v1.12.1@sha256:65bd34918063ae36550a7351e458aff5589463605bc2db08f3043ca7017ed30d"
  }
}

github_runners_sg_id = "sg-02d3b6b7a8df9c9ee"

eks_auth = [
  {
    groups = ["system:masters"]
    role_arn = "arn:aws:iam::794703684555:role/GitHubActionIACAdmin"
  },
  {
    groups = ["system:masters"]
    role_arn = "arn:aws:iam::794703684555:role/GitHubActionIACECSRunner"
  },
  {
    groups = ["system:masters"]
    role_arn = "arn:aws:iam::794703684555:role/GitHubActionIACReadOnly"
  }
]

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
