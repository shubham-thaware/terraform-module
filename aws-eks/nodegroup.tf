resource "aws_eks_node_group" "default" {
  #count           = var.create_spot_node_group ? 0 : 1
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.aws_eks_cluster_name}-ng"
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
    "k8s.io/cluster-autoscaler/enabled"                     = "true",
    "k8s.io/cluster-autoscaler/${var.aws_eks_cluster_name}" = "owned",
    "Name"                                                  = "${var.aws_eks_cluster_name}-ng"
  })

  depends_on = [aws_eks_cluster.this, aws_launch_template.eks_nodes]
}

# Optional spot node group
resource "aws_eks_node_group" "spot" {
  count = var.create_spot_node_group ? 0 : 1

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.aws_eks_cluster_name}-ng-spot"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.aws_vpc_private_subnet_ids
  capacity_type   = "SPOT"
  instance_types  = var.spot_instance_types

  scaling_config {
    desired_size = var.spot_desired_size
    max_size     = var.spot_max_size
    min_size     = var.spot_min_size
  }

  tags = merge(var.default_tags, { Name = "${var.aws_eks_cluster_name}-ng-spot" })

  depends_on = [aws_eks_cluster.this]
}
