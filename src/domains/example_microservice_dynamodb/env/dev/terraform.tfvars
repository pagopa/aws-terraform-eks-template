env_short         = "d"
environment       = "dev"
app_name          = "dvopla-dynamodb"
namespace         = "example-dynamodb"
oidc_provider_arn = "arn:aws:iam::794703684555:oidc-provider/oidc.eks.eu-south-1.amazonaws.com/id/196F5E82730D03D93DC0C77CD5A4E4E0"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
