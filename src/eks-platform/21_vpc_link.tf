resource "aws_api_gateway_vpc_link" "this" {
  name        = local.project
  description = "Connect to ${local.project} K8s external NLB"
  target_arns = [module.nlb.lb_arn]
}
