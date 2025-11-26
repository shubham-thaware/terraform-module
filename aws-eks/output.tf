output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_ca" {
  description = "Cluster certificate authority data"
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "nodegroup_1_arn" {
  description = "ARN of node group 1"
  value       = aws_eks_node_group.nodes_1.arn
}

output "nodegroup_2_arn" {
  description = "ARN of node group 2"
  value       = aws_eks_node_group.nodes_2.arn
}

output "cluster_autoscaler_role_arn" {
  description = "IAM Role ARN for Cluster Autoscaler"
  value       = aws_iam_role.cluster_autoscaler.arn
}
