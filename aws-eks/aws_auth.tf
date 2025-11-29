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

