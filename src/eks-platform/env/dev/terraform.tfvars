env_short   = "d"
environment = "dev"
app_name    = "template"

vpc = {
  id                  = "vpc-0af6c8eebde933d1f"
  intra_subnets_ids   = ["subnet-009b96cfaa0b34f36", "subnet-013c0d6ca86144f85", "subnet-0bd860e53b392924c"]
  private_subnets_ids = ["subnet-0f9a054cdd48e522c", "subnet-0ce9e6f1fec6b37c8", "subnet-017d62f6f7a7ee405"]
  public_subnets_ids  = ["subnet-07085b92d54822442", "subnet-0c1e233657bf5b033", "subnet-033a7add8fbd32090"]
}

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "PagoPa"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TSXXX - AREA"
}
