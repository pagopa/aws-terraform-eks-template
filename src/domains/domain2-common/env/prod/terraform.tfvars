prefix      = "dvopla"
env_short   = "p"
environment = "prod"

# Ref: https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/132810155/Azure+-+Naming+Tagging+Convention#Tagging
tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "Product"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template/tree/main/src/domain2-common"
  CostCenter  = "TSXXX - AREA"
}
