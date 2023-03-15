variable "aws_region" {
  description = "AWS region to create resources. Default Milan"
  default     = "eu-south-1"
  type        = string
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

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "cidr" {
  description = "VPC cidr."
  default     = "10.0.0.0/16"
  type        = string
}

variable "public_subnets_cidr" {
  description = "Public subnets list of cidr."
  default     = ["10.0.250.0/26", "10.0.250.64/26", "10.0.250.128/26"]
  type        = list(string)
}

variable "enable_single_nat_gateway" {
  description = "Whether to use a single NAT gateway or one NAT gateway per AZZ"
  default     = false
  type        = bool
}
