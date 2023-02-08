variable "aws_region" {
  type        = string
  description = "AWS region to create resources. Default Milan"
  default     = "eu-south-1"
}

variable "app_name" {
  type        = string
  description = "App name."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment"
}

variable "env_short" {
  type        = string
  default     = "d"
  description = "Evnironment short."
}

variable "vpc" {
  description = "VPC configuration"
  type = object({
    id                  = string
    private_subnets_ids = list(string)
    intra_subnets_ids   = list(string)
    public_subnets_ids  = list(string)
  })
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
  default     = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes <major>.<minor> version to use for the EKS cluster (i.e.: 1.24)"
  default     = "1.24"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}
