resource "aws_api_gateway_rest_api" "this" {
  name = local.project
  body = templatefile(var.api_openapi_spec_path, {
    vpc_link_id       = var.vpc_link_id
    load_balancer_dns = var.cluster_nlb_url
    cors_fqdn         = var.cors_fqdn
    apigw_token       = data.aws_secretsmanager_secret_version.apigw_token.secret_string
  })
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  cache_cluster_size = "0.5"
  deployment_id      = aws_api_gateway_deployment.this.id
  rest_api_id        = aws_api_gateway_rest_api.this.id
  stage_name         = var.api_stage_name
}

resource "aws_wafv2_web_acl_association" "this" {
  resource_arn = aws_api_gateway_stage.this.arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

