variable "aws_eks_cluster_name" {
    description = "Name of the EKS cluster"
    type = string
  
}

variable "aws_eks_cluster_version" {
    description = "AWS EKS cluster Version"
    type = string
    default     = null  
}

variable "aws_vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "aws_vpc_private_subnet_ids" {
    description = "List of private subnet IDs for EKS nodes (must be in at least 2 AZs)"
    type        = list(string)
}

variable "aws_eks_cluster_sg_ids" {
  description = "Security group ID for EKS control plane"
  type        = string
}