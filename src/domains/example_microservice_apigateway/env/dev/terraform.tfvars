env_short       = "d"
environment     = "dev"
app_name        = "dvopla-apigateway"
cluster_name    = "dvopla-d"
cluster_subnet_ids = ["subnet-07e9a9e1f8a121a2a", "subnet-029c6bb683161a612", "subnet-01f308ca17bc5a827"]
cluster_nlb_arn = "arn:aws:elasticloadbalancing:eu-south-1:794703684555:loadbalancer/net/dvopla-d/eea79f09ff7b0c1a"
cluster_nlb_url = "dvopla-d-eea79f09ff7b0c1a.elb.eu-south-1.amazonaws.com"
cluster_vpc_id  = "vpc-07e680d083d85f636"
vpc_link_id     = "nt64u8"
namespace       = "example"
port            = 3000

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
