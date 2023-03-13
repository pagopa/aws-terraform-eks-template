env_short       = "d"
environment     = "dev"
app_name        = "dynamodb"
namespace       = "echoserver"
oidc_provider_arn = "arn:aws:iam::794703684555:oidc-provider/oidc.eks.eu-south-1.amazonaws.com/id/15EAE9181C2B6F18E92928A296749D8F"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
