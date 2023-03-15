output "cluster_endpoint" {
  description = "Endpoint for the Kubernetes API"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_nlb_arn" {
  description = "ARN of the NLB in front of the cluser"
  value       = module.nlb.lb_arn
}

output "cluster_nlb_url" {
  description = "URL of the NLB in front of the cluser"
  value       = module.nlb.lb_dns_name
}

output "cluster_oidc_provider_arn" {
  description = "OIDC provider arn of the cluster"
  value       = module.eks.oidc_provider_arn
}

output "vpc_link_id" {
  description = "ID of the VPC connected to the cluster NLB"
  value       = aws_api_gateway_vpc_link.this.id
}
