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
  type        = list(string)
}

variable "allowed_cidr" {
  description = "Cidr allowed to access the cluster"
  type        = list(string)
}

variable "namespace" {
  description = "Kubernetes namespace to release these services into"
  type        = string
}

variable "cluster_min_capacity" {
  description = "Aurora serverless cluster min capacity"
  type        = number
}

variable "cluster_max_capacity" {
  description = "Aurora serverless cluster max capacity"
  type        = number
}
