env_short   = "u"
environment = "uat"
app_name    = "dvopla"

vpc_enable_single_nat_gateway = true

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
