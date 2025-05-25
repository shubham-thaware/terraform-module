output "jump_sg_id" {
  description = "ID of the jump server security group"
  value       = aws_security_group.bastion-sg.id
}

output "db_sg_id" {
  description = "ID of the database security group"
  value       = aws_security_group.database-sg.id
}

output "eks_cluster_sg_id" {
  description = "ID of the EKS cluster security group"
  value       = aws_security_group.eks_cluster.id
}