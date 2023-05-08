env_short       = "d"
environment     = "dev"
app_name        = "dvopla-apigateway"
cluster_nlb_url = "dvopla-d-nlb-0dceb02c57146cd0.elb.eu-south-1.amazonaws.com"
vpc_link_id     = "anuipc"
namespace       = "example-apigateway"
cors_fqdn       = "https://d3av01txhd75u9.cloudfront.net"

reloader = {
  chart_version = "v1.0.22"
  image_name    = "ghcr.io/stakater/reloader"
  image_tag     = "v1.0.22@sha256:c768605b16baa78c075d1bfb2122281201fd2da674ce1d6b410fa929c157693b"
}

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/aws-terraform-eks-template"
  CostCenter  = "TS310 - PAGAMENTI E SERVIZI"
}
