output "cluster_endpoint" {
  description = "Endpoint for the Kubernetes API"
  value       = module.eks.cluster_endpoint
}
