# Cluster identity
output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "cluster_version" {
  value = aws_eks_cluster.this.version
}

output "cluster_certificate_authority_data" {
  value     = aws_eks_cluster.this.certificate_authority[0].data
  sensitive = true
}

# IAM
output "cluster_iam_role_arn" {
  value = aws_iam_role.cluster.arn
}

output "cluster_iam_role_name" {
  value = aws_iam_role.cluster.name
}

# OIDC Issuer
output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# Security group
output "cluster_primary_security_group_id" {
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

# Node Group outputs (default)
output "node_group_public_arn" {
  value = aws_eks_node_group.default.arn
}

output "node_group_public_id" {
  value = aws_eks_node_group.default.id
}

output "node_group_public_status" {
  value = aws_eks_node_group.default.status
}

output "node_group_public_version" {
  value = aws_eks_node_group.default.version
}

output "node_group_1_arn" {
  value = aws_eks_node_group.ng_1.arn
}

output "node_group_2_arn" {
  value = aws_eks_node_group.ng_2.arn
}

output "node_group_1_status" {
  value = aws_eks_node_group.ng_1.status
}

output "node_group_2_status" {
  value = aws_eks_node_group.ng_2.status
}


