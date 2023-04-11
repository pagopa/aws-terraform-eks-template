env_short   = "d"
environment = "dev"
app_name    = "dvopla"

vpc_id                 = "vpc-07e680d083d85f636"
nat_gateway_ids        = ["nat-00513a086ac6d89dd"]
enable_public_endpoint = true
namespaces             = ["example"]

aws_load_balancer_controller = {
  helm_version         = "1.4.7"
  replica_count        = 1
  namespace            = "kube-system"
  service_account_name = "aws-load-balancer-controller"
}

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
