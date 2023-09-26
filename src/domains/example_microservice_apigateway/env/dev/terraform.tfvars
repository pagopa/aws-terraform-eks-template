env_short                 = "d"
environment               = "dev"
app_name                  = "dvopla-apigateway"
cluster_nlb_url           = "dvopla-d-nlb-0274d162a444f41b.elb.eu-south-1.amazonaws.com"
cluster_security_group_id = "sg-0bb07dafbb14e5f5d"
vpc_id                    = "vpc-0e0d4f97216bd34c9"
vpc_link_id               = "uvmvii"
alb_listener_arn          = "arn:aws:elasticloadbalancing:eu-south-1:794703684555:listener/app/dvopla-d-alb/e1f878ff0bdfbfd3/ef0bd8aaf72d18b2"
namespace                 = "example-apigateway"
cors_fqdn                 = "https://cdn.dev.eks.pagopa.it"

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
