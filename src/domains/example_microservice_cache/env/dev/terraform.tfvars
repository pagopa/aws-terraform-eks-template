env_short   = "d"
environment = "dev"
app_name    = "dvopla-cache"
namespace   = "example"

vpc_id       = "vpc-07e680d083d85f636"
subnets_cidr = ["10.0.129.0/26", "10.0.129.64/26", "10.0.129.128/26"]
cluster_security_group_id = "sg-0788bf4a588090ae7"

node_type                = "cache.t4g.micro"
redis_version            = "7.0"
snapshot_retention_limit = 0
cluster_replicas         = 1
enable_multiaz           = false
apply_immediately        = true

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
