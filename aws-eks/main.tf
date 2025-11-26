resource "aws_eks_cluster" "cluster" {
  name     = var.aws_eks_cluster_name
  role_arn = aws_iam_role.cluster.arn
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

resource "aws_eks_node_group" "nodes_1" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.aws_eks_cluster_name}-eks-node-group-1"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.aws_vpc_private_subnet_ids
  version         = var.aws_eks_cluster_version
  instance_types  = [var.eks_instance_type]

  scaling_config {
    desired_size = var.eks_desired_size
    max_size     = var.eks_max_size
    min_size     = var.eks_min_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_eks_cluster.cluster
  ]

  tags = {
    name = "${var.aws_eks_cluster_name}-eks-node-group-1"
  }
}

resource "aws_eks_node_group" "nodes_2" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.aws_eks_cluster_name}-eks-node-group-2"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.aws_vpc_private_subnet_ids
  version         = var.aws_eks_cluster_version
  instance_types  = [var.eks_instance_type]

  scaling_config {
    desired_size = var.eks_desired_size
    max_size     = var.eks_max_size
    min_size     = var.eks_min_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_eks_cluster.cluster
  ]

  tags = {
    name = "${var.aws_eks_cluster_name}-eks-node-group-2"
  }
}

# Kubernetes provider for IRSA service accounts
provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.cluster.name
}

# Cluster Autoscaler Service Account
resource "kubernetes_service_account" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler.arn
    }
  }

  depends_on = [
    aws_iam_role.cluster_autoscaler,
    aws_eks_cluster.cluster
  ]
}
