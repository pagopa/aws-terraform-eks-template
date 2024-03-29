output "cluster_endpoint" {
  description = "Endpoint for the Kubernetes API"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_subnet_ids" {
  description = "Subnet ids of the EKS cluster"
  value       = aws_subnet.this[*].id
}

output "cluster_nlb_arn" {
  description = "ARN of the NLB in front of the cluster"
  value       = module.nlb.lb_arn
}

output "cluster_nlb_url" {
  description = "URL of the NLB in front of the cluster"
  value       = module.nlb.lb_dns_name
}

output "cluster_alb_url" {
  description = "ARN of the ALB in front of the cluster"
  value       = module.alb.lb_arn
}

output "cluster_alb_name" {
  description = "Name of the ALB in front of the cluster"
  value       = "${local.project}-alb"
}

output "cluster_security_group_id" {
  description = "Id of the default cluster security group id"
  value       = module.eks.cluster_primary_security_group_id
}

output "cluster_oidc_provider_arn" {
  description = "OIDC provider arn of the cluster"
  value       = module.eks.oidc_provider_arn
}

output "external_alb_listener_arns" {
  description = "ARN of the listeners (TCP and HTTP) configured in the external cluster ALB"
  value       = module.alb.http_tcp_listener_arns
}

output "vpc_link_id" {
  description = "ID of the VPC connected to the cluster NLB"
  value       = aws_api_gateway_vpc_link.this.id
}
