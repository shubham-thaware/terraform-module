resource "aws_eks_cluster" "this" {
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

  enabled_cluster_log_types = var.control_plane_log_types

dynamic "encryption_config" {
  for_each = var.enable_kms ? [1] : []

  content {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.cluster[0].arn
    }
  }
}


  tags = merge(var.default_tags, { "Name" = var.aws_eks_cluster_name })

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_cluster_vpc_policy
  ]
}

resource "aws_kms_key" "cluster" {
  count = var.enable_kms ? 1 : 0

  description             = "KMS key for EKS cluster ${var.aws_eks_cluster_name} (secrets)"
  deletion_window_in_days = 30
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "Enable IAM User Permissions",
        Effect    = "Allow",
        Principal = { AWS = "*" },
        Action    = "kms:*",
        Resource  = "*"
      }
    ]
  })
}
