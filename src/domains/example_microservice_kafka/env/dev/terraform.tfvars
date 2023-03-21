env_short   = "d"
environment = "dev"
app_name    = "dvopla-msk"

vpc_id                = "vpc-07e680d083d85f636"
subnets_cidr          = ["10.0.130.0/26", "10.0.130.64/26", "10.0.130.128/26"]
eks_security_group_id = "sg-0788bf4a588090ae7"

namespace       = "example"
broker_replicas = 3
broker_type     = "kafka.t3.small"
broker_storage  = 10

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
