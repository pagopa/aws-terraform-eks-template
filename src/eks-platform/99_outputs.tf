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

output "allow_ingress_sg_ig" {
  description = "Security Group ID to allow incoming connection from cluster NLB"
  value       = aws_security_group.allow_from_nlb.id
}
