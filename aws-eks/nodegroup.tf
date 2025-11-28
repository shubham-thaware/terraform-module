#############################################
# Node Group 1
#############################################
resource "aws_eks_node_group" "ng_1" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.aws_eks_cluster_name}-ng-1"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.aws_vpc_private_subnet_ids

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = var.node_desired
    max_size     = var.node_max
    min_size     = var.node_min
  }

  tags = merge(var.default_tags, {
    "Name"                                         = "${var.aws_eks_cluster_name}-ng-1"
    "k8s.io/cluster-autoscaler/enabled"            = "true"
    "k8s.io/cluster-autoscaler/${var.aws_eks_cluster_name}" = "owned"
  })

  depends_on = [
    aws_eks_cluster.this,
    aws_launch_template.eks_nodes
  ]
}

#############################################
# Node Group 2
#############################################
resource "aws_eks_node_group" "ng_2" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.aws_eks_cluster_name}-ng-2"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.aws_vpc_private_subnet_ids

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = var.node_desired
    max_size     = var.node_max
    min_size     = var.node_min
  }

  tags = merge(var.default_tags, {
    "Name"                                         = "${var.aws_eks_cluster_name}-ng-2"
    "k8s.io/cluster-autoscaler/enabled"            = "true"
    "k8s.io/cluster-autoscaler/${var.aws_eks_cluster_name}" = "owned"
  })

  depends_on = [
    aws_eks_cluster.this,
    aws_launch_template.eks_nodes
  ]
}
