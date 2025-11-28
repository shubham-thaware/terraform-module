########################################
# EKS Data Sources
########################################

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.this.name

  depends_on = [aws_eks_cluster.this]
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.this.name

  depends_on = [aws_eks_cluster.this]
}

########################################
# Kubernetes Provider (Safe Version)
########################################

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}





########################################
# aws-auth ConfigMap (Node IAM Mapping)
########################################

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.eks_nodes.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])
  }

  depends_on = [
    aws_eks_cluster.this,
    aws_iam_role.eks_nodes
  ]
}

########################################
# Cluster Autoscaler Service Account (IRSA)
########################################

resource "kubernetes_service_account" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler.arn
    }
  }

  depends_on = [
    aws_eks_cluster.this,
    aws_iam_role.cluster_autoscaler,
    kubernetes_config_map.aws_auth
  ]
}

########################################
# EBS CSI Driver Addon (Pinned & Safe)
########################################

resource "aws_eks_addon" "ebs_csi" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "aws-ebs-csi-driver"
  service_account_role_arn    = aws_iam_role.ebs_csi.arn
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  addon_version = var.ebs_csi_version # e.g. v1.31.0-eksbuild.1

  depends_on = [
    aws_eks_cluster.this,
    aws_iam_role.ebs_csi
  ]
}
