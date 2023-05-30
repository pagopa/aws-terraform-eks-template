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

variable "cluster_nlb_url" {
  description = "Kubernetes network load balancer arn"
  type        = string
}

variable "cluster_security_group_id" {
  description = "Security group id of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC id to deploy the ALB target group"
  type        = string
}

variable "alb_listener_arn" {
  description = "ARN of the ALB listener"
  type        = string
}

variable "vpc_link_id" {
  description = "VPC link id targeting cluster NLB"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to release these services into"
  type        = string
}

variable "reloader" {
  description = "Reloader configuration"
  type = object({
    chart_version = string
    image_name    = string
    image_tag     = string
  })
}

variable "cors_fqdn" {
  description = "FQDN to allow CORS"
  type        = string
}

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
