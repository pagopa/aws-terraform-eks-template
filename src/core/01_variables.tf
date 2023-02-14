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

#####
# VPC
#####

variable "vpc_cidr" {
  description = "VPC cidr."
  default     = "10.0.0.0/16"
  type        = string
}

variable "vpc_private_subnets_cidr" {
  description = "Private subnets list of cidr."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  type        = list(string)
}

variable "vpc_public_subnets_cidr" {
  description = "Private subnets list of cidr."
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  type        = list(string)
}

variable "vpc_internal_subnets_cidr" {
  description = "Internal subnets list of cidr. Mainly for private endpoints"
  default     = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
  type        = list(string)
}

########################
# CloudFront and origins
########################

variable "cf_aliases" {
  description = "Extra CNAMEs for the distribution"
  default     = []
  type        = list(string)
}

variable "cf_certificate_arn" {
  description = "The SSL certificate arn for the given aliases"
  default     = null
  type        = string
}

variable "cf_price_class" {
  description = "https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PriceClass.html"
  default     = "PriceClass_100"
  type        = string

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.cf_price_class)
    error_message = "Allowed values for cf_price_class are \"PriceClass_100\", \"PriceClass_200\", \"PriceClass_All\"."
  }
}

variable "cf_default_root_object" {
  description = "The to return when an end user requests the root URL"
  default     = "index.html"
  type        = string
}

variable "cf_geo_restriction" {
  description = "The geographical restriction for the distribution (locations are ISO 3166-1-alpha-2 codes compliant)"
  default     = {
    type      = "none"
    locations = []
  }
  type = object({
    type      = string
    locations = list(string)
  })

  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.cf_geo_restriction.type)
    error_message = "Allowed values for cf_geo_restriction.type are \"none\", \"whitelist\", \"blacklist\"."
  }
  type = object({
    type      = string
    locations = list(string)
  })

  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.cf_geo_restriction.type)
    error_message = "Allowed values for cf_geo_restriction.type are \"none\", \"whitelist\", \"blacklist\"."
  }
}

variable "cf_create_log_bucket" {
  description = "If enabled, the bucket to store CloudFront logs will created"
  default     = false
  type        = bool
}

variable "cf_log_bucket_domain_name" {
  description = "Use an existing bucket to store CloudFront logs"
  default     = null
  type        = string
}

variable "cf_create_monitoring_subscription" {
  description = "If enabled, the resource for monitoring subscription will created"
  default     = false
  type        = bool
}

#############
# API Gateway
#############

variable "api_openapi_spec_path" {
  description = "Path of the OpenAPI spec to import in the API Gateway"
  default     = "assets/openapi_specs/default.yaml"
  type        = string
}

variable "api_stage_name" {
  description = "Name of the stage, it will be used as basepath"
  default     = "services"
  type        = string
}

variable "api_create_waf_metrics" {
  description = "If enabled, WAF sends metrics to CloudWatch"
  default     = false
  type        = bool
}

variable "api_sample_waf_requests" {
  description = "If enabled, WAF requests are sampled"
  default     = false
  type        = bool
}

variable "cf_create_log_bucket" {
  description = "If enabled, the bucket to store CloudFront logs will created"
  default     = false
  type        = bool
}

variable "cf_log_bucket_domain_name" {
  description = "Use an existing bucket to store CloudFront logs"
  default     = null
  type        = string
}

variable "cf_create_monitoring_subscription" {
  description = "If enabled, the resource for monitoring subscription will created"
  default     = false
  type        = bool
}

#############
# API Gateway
#############

variable "api_openapi_spec_path" {
  description = "Path of the OpenAPI spec to import in the API Gateway"
  default     = "assets/openapi_specs/default.yaml"
  type        = string
}

variable "api_stage_name" {
  description = "Name of the stage, it will be used as basepath"
  default     = "services"
  type        = string
}
