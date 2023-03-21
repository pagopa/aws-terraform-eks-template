env_short   = "d"
environment = "dev"
app_name    = "dvopla-rds"

vpc_id       = "vpc-07e680d083d85f636"
subnets_cidr = ["10.0.128.0/26", "10.0.128.64/26", "10.0.128.128/26"]

namespace             = "example"
cluster_min_capacity  = 1
cluster_max_capacity  = 2
eks_security_group_id = "sg-0788bf4a588090ae7"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
