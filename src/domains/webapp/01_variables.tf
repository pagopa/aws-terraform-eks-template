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
  default = {
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
