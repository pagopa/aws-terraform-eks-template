env_short   = "d"
environment = "dev"
app_name    = "dvopla"

enable_one_natgw_per_az = false

github_runners = {
  subnet_cidr = "10.0.250.192/26"
  image_uri   = "ghcr.io/pagopa/github-self-hosted-runner-aws:v1.0.0"
  cpu         = 1024
  memory      = 2048
}

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
