env_short       = "d"
environment     = "dev"
app_name        = "echoserver"
cluster_nlb_arn = "arn:aws:elasticloadbalancing:eu-south-1:794703684555:loadbalancer/net/dvopla-d/74664777eb9d5da1"
cluster_vpc_id  = "vpc-0e66e883cef1bf2fc"
namespace       = "echoserver"
port            = 3000

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
