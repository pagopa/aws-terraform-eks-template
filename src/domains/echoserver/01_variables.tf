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

variable "cluster_vpc_id" {
  description = "Kubernetes VPC"
  type        = string
}

variable "cluster_nlb_arn" {
  description = "Kubernetes network load balancer arn"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to release these services into"
  type        = string
}

variable "port" {
  description = "Microservice default port"
  type        = string
}
