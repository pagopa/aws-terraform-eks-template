output "api_gateway_id" {
  description = "API Gateway id"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_stage_domain_name" {
  description = "Domain name of the API main stage"
  value       = aws_api_gateway_stage.this.invoke_url
}
