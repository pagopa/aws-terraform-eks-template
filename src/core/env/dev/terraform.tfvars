env_short   = "d"
environment = "dev"
app_name    = "dvopla"

vpc_enable_single_nat_gateway = true

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
