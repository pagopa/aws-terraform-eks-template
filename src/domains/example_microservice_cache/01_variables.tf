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

variable "node_type" {
  description = "https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/CacheNodes.SupportedTypes.html"
  type        = string
}

variable "redis_version" {
  description = "https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/supported-engine-versions.html"
  type        = string
}

variable "maintenance_window" {
  description = "Weekly maintenance window (minimum 60 minutes) during which any system changes are applied, format ddd:hh24:mi-ddd:hh24:mi (ie mon:23:00-tue:01:00)"
  default     = "mon:02:00-mon:03:00"
  type        = string
  # TODO constraint format
}

variable "snapshot_window" {
  description = "A period (minimum 60 minutes) during each day when ElastiCache will begin creating a backup, format hh24:mi-hh24:mi (ie 04:00-09:00)"
  default     = "04:00-05:00"
  type        = string
}

variable "snapshot_retention_limit" {
  description = "The number of days (maximum 35 days) the backup will be retained, set 0 to disable automatic backups"
  default     = 30
  type        = number
}

variable "cluster_replicas" {
  description = "Number of cache clusters (primary and replicas) this replication group will have"
  default     = 2
  type        = number
}

variable "enable_multiaz" {
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, num_cache_clusters must be greater than 1"
  default     = true
  type        = bool
}

variable "enable_encryption" {
  description = "Whatever enable encryption at-rest and in-transit, this could impact performance"
  default     = false
  type        = bool
}

variable "apply_immediately" {
  description = "Some changes could be applied in the next maintenante window, meantime Terraform may report plan differences. This flag instructs to apply changes immediatly but it may cause brief downtime as servers reboots"
  default     = false
  type        = bool
}

variable "eks_security_group_id" {
  description = "Security group of the EKS cluster"
  type        = string
}
