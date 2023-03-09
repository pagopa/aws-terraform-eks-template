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
