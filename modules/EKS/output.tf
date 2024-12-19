output "cluster_endpoint" {
  description = "Endpoint for Amazon Web Service EKS "
  value = aws_eks_cluster.eks.endpoint
}