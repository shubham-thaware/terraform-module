##############################################
# EKS Cluster Outputs
##############################################

output "cluster_name" {
  description = "Name of the EKS Cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "API Server endpoint of the EKS Cluster"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca" {
  description = "Base64 encoded CA certificate data"
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}

##############################################
# Node Group Outputs
##############################################

output "nodegroup_arn" {
  description = "ARN of the default EKS Node Group"
  value       = aws_eks_node_group.default.arn
}

##############################################
# IAM Outputs
##############################################

output "cluster_autoscaler_role_arn" {
  description = "IAM Role ARN for Cluster Autoscaler"
  value       = aws_iam_role.cluster_autoscaler.arn
}

output "ebs_csi_role_arn" {
  description = "IAM Role ARN for EBS CSI Driver"
  value       = aws_iam_role.ebs_csi.arn
}
