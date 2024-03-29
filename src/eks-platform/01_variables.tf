variable "aws_region" {
  description = "AWS region to create resources. Default Milan"
  default     = "eu-south-1"
  type        = string
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "app_name" {
  description = "App name."
  type        = string
}

variable "environment" {
  description = "Environment"
  default     = "dev"
  type        = string
}

variable "env_short" {
  description = "Evnironment short."
  default     = "d"
  type        = string
}

variable "azs" {
  description = "Availability zones"
  default     = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "subnets_cidr" {
  description = "Cidr of the cluster subnets, should be one subnet per AZ"
  default     = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  type        = list(string)
}

variable "nat_gateway_ids" {
  description = "Ids of NAT gateways to route traffic to"
  type        = list(string)
}

variable "enable_public_endpoint" {
  description = "Determines whether the Kubernetes API are public or not"
  default     = false
  type        = bool
}

variable "cluster_version" {
  description = "Kubernetes <major>.<minor> version to use for the EKS cluster (i.e.: 1.24)"
  default     = "1.26"
  type        = string
}

variable "aws_load_balancer_controller" {
  description = "AWS Load Balancer controller configuration"
  type = object({
    chart_version        = string
    replica_count        = number
    namespace            = string
    service_account_name = string
    image_name           = string
    image_tag            = string
  })
}

variable "keda" {
  description = "Keda configuration"
  type = object({
    chart_version = string
    namespace     = string
    keda = object({
      image_name = string
      image_tag  = string
    })
    metrics_api_server = object({
      image_name = string
      image_tag  = string
    })
    webhooks = object({
      image_name = string
      image_tag  = string
    })

  })
}
variable "prometheus" {
  description = "Prometheus configuration"
  type = object({
    chart_version = string,
    configmap_reload_prometheus = object({
      image_name = string,
      image_tag  = string,
    }),
    node_exporter = object({
      image_name = string,
      image_tag  = string,
    }),
    server = object({
      image_name = string,
      image_tag  = string,
    }),
    pushgateway = object({
      image_name = string,
      image_tag  = string,
    }),
  })
}

variable "metrics_server" {
  description = "K8s metrics server configuration"
  type = object({
    chart_version = string
    namespace     = string
    image_name    = string
    image_tag     = string
  })
}

variable "reloader" {
  description = "Reloader configuration"
  type = object({
    chart_version = string
    image_name    = string
    image_tag     = string
  })
}

variable "cert_manager" {
  description = "CertManager configuration"
  type = object({
    chart_version = string
    namespace     = string
    controller = object({
      image_name = string,
      image_tag  = string,
    }),
    cainjector = object({
      image_name = string,
      image_tag  = string,
    }),
    webhook = object({
      image_name = string,
      image_tag  = string,
    })
    startupapicheck = object({
      image_name = string,
      image_tag  = string,
    })
    acmesolver = object({
      image_name = string,
      image_tag  = string,
    })
  })
}

variable "sentinel_bucket_arn" {
  description = "S3 bucket arn connect to sentinel"
  default     = null
  type        = string
}

variable "github_runners_sg_id" {
  description = "Security group of the GitHub Runners"
  default     = null
  type        = string
}

variable "build_lambdas_in_docker" {
  description = "Whatever build lambdas in Docker or host"
  default     = true
  type        = bool
}

variable "eks_auth" {
  description = "List of roles and ClusterRoleBindings"
  default     = []
  type = list(object({
    groups   = list(string)
    role_arn = string
  }))
}

variable "kms_auth" {
  description = "List of principal arns to access EKS encryption keys"
  default = {
    admins   = []
    services = []
    users    = []
  }
  type = object({
    admins   = list(string) # https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-administrators
    services = list(string) # https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration
    users    = list(string) # https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-users
  })
}
