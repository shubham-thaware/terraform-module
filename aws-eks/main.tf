resource "aws_eks_cluster" "cluster" {
  name     = var.aws_eks_cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.aws_eks_cluster_version
  vpc_config {
    subnet_ids              = var.aws_vpc_private_subnet_ids
    endpoint_private_access = var.eks_endpoint_private_access
    endpoint_public_access  = var.eks_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
    security_group_ids      = var.aws_eks_cluster_sg_ids  
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_cluster_vpc_policy,
    aws_iam_role_policy_attachment.eks_service_policy
  ]
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.aws_eks_cluster_name}-eks-node-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.aws_vpc_private_subnet_ids
  version         = var.aws_eks_cluster_version 
  instance_types  = [var.eks_instance_type]

  scaling_config {
    desired_size = var.eks_desired_size
    max_size     = var.eks_max_size
    min_size     = var.eks_min_size
  }

  depends_on = [
    aws_eks_cluster.cluster,
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_readonly,
  ]
  tags = {
    name      = "${var.aws_eks_cluster_name}-eks-node-group"
  }
}
