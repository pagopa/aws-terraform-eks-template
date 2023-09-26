env_short      = "d"
environment    = "dev"
app_name       = "dvopla-cloudfront"
alias          = "cdn.dev.eks.pagopa.it"
hosted_zone_id = "Z05537163V0KMF7URC22J"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
