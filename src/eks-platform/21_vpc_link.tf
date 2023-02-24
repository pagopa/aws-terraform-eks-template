# resource "aws_api_gateway_vpc_link" "this" {
#   name        = local.project
#   description = "${local.project} link to cluster NLB"
#   target_arns = [module.nlb.lb_arn]
# }

