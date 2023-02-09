variable "aws_region" {
  description = "AWS region to create resources. Default Milan"
  type        = string
  default     = "eu-south-1"
}

variable "app_name" {
  description = "App name."
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "env_short" {
  description = "Evnironment short."
  type        = string
  default     = "d"
}

variable "vpc" {
  description = "VPC configuration"
  type = object({
    id                  = string
    private_subnets_ids = list(string)
    intra_subnets_ids   = list(string)
  })
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
}

variable "enable_public_endpoint" {
  description = "Determines whether the Kubernetes API are public or not"
  type        = bool
  default     = false
}

variable "cluster_version" {
  description = "Kubernetes <major>.<minor> version to use for the EKS cluster (i.e.: 1.24)"
  type        = string
  default     = "1.24"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}
