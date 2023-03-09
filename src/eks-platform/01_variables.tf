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

variable "vpc" {
  description = "VPC configuration"
  type = object({
    id                  = string
    private_subnets_ids = list(string)
    intra_subnets_ids   = list(string)
  })
}

variable "enable_public_endpoint" {
  description = "Determines whether the Kubernetes API are public or not"
  default     = false
  type        = bool
}

variable "cluster_version" {
  description = "Kubernetes <major>.<minor> version to use for the EKS cluster (i.e.: 1.24)"
  default     = "1.24"
  type        = string
}

variable "namespaces" {
  description = "For each namespace this module will create a Fargate profile and a K8s namespace"
  default     = []
  type        = list(string)
}

variable "aws_load_balancer_controller" {
  description = "AWS Load Balancer controller configuration"
  type = object({
    helm_version         = string
    replica_count        = number
    namespace            = string
    service_account_name = string
  })
}
