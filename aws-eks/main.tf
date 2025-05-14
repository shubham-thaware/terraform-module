# EKS Cluster
resource "aws_eks_cluster" "cluster" {
  name     = var.aws_eks_cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.aws_eks_cluster_version
  vpc_config {
    subnet_ids              = var.aws_vpc_private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [var.aws_eks_cluster_sg_ids]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy
  ]
}







# EKS Node Group (2 t2.medium nodes)
# EKS Node Group (1 t3.medium node)
resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.aws_eks_cluster_name}-eks-node-groups"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.aws_vpc_private_subnet_ids

  instance_types  = ["t3.medium"]        # Changed from t2.medium
  ami_type        = "AL2_x86_64"         # Optional: Use Amazon Linux 2 for better compatibility

  scaling_config {
    desired_size = 1
    max_size     = 4
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.cluster,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_readonly,
  ]
}