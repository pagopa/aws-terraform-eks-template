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

variable "alias" {
  description = "Extra CNAME for the distribution"
  type        = string
}

variable "hosted_zone_id" {
  description = "Id of the Route53 hosted zone"
  type        = string
}

variable "price_class" {
  description = "https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PriceClass.html"
  default     = "PriceClass_100"
  type        = string

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "Allowed values for price_class are \"PriceClass_100\", \"PriceClass_200\", \"PriceClass_All\"."
  }
}

variable "default_root_object" {
  description = "The to return when an end user requests the root URL"
  default     = "index.html"
  type        = string
}

variable "geo_restriction" {
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
    condition     = contains(["none", "whitelist", "blacklist"], var.geo_restriction.type)
    error_message = "Allowed values for geo_restriction.type are \"none\", \"whitelist\", \"blacklist\"."
  }
}

variable "create_monitoring_subscription" {
  description = "If enabled, the resource for monitoring subscription will created"
  default     = false
  type        = bool
}
