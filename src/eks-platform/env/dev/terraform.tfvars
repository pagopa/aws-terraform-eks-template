env_short   = "d"
environment = "dev"
app_name    = "dvopla"

vpc = {
  id = "vpc-0e66e883cef1bf2fc"
  intra_subnets_ids = [
    "subnet-056f4c328617b7b75",
    "subnet-073300df47548d58a",
    "subnet-0b395725c694fea5c",
  ]
  private_subnets_ids = [
    "subnet-0a530b8bb0301ab24",
    "subnet-057a04e23ea870b58",
    "subnet-04c042d372d21fe1a",
  ]
  public_subnets_ids = [
    "subnet-09dfcc93797826229",
    "subnet-0d31a81a8c82c4ded",
    "subnet-03175ce3f5744b3f6",
  ]
}

enable_public_endpoint = true
create_echo_server     = true

ingress = {
  helm_version  = "1.4.7"
  replica_count = 1
  namespace     = "ingress"
}

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
