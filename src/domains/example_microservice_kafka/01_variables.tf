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

variable "namespace" {
  description = "Kubernetes namespace to release these services into"
  type        = string
}

variable "kafka_version" {
  description = "https://docs.aws.amazon.com/msk/latest/developerguide/supported-kafka-versions.html"
  type        = string
}

variable "broker_replicas" {
  description = "Number of broker nodes"
  type        = number
}

variable "broker_type" {
  description = "https://docs.aws.amazon.com/msk/latest/developerguide/bestpractices.html#bestpractices-right-size-cluster"
  type        = string
}

variable "broker_storage" {
  description = "Number of GiB on each broker node from 1 to 16384"
  type        = number
}

variable "eks_security_group_id" {
  description = "Security group of the EKS cluster"
  type        = string
}
