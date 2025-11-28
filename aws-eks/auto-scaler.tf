resource "helm_release" "cluster_autoscaler" {
  name      = "cluster-autoscaler"
  namespace = "kube-system"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.37.0" # ✅ Stable version for 2025

  values = [
    yamlencode({
      autoDiscovery = {
        clusterName = aws_eks_cluster.this.name
      }

      cloudProvider = "aws"
      awsRegion     = var.aws_region

      rbac = {
        serviceAccount = {
          create = false
          name   = "cluster-autoscaler"
        }
      }

      extraArgs = {
        balance-similar-node-groups = "true"
        skip-nodes-with-system-pods = "false"
        expander                    = "least-waste"
        v                           = "4"
      }

      nodeSelector = {
        "kubernetes.io/os" = "linux"
      }

      tolerations = [
        {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }
      ]
    })
  ]

  depends_on = [
    kubernetes_service_account.cluster_autoscaler,
    aws_iam_role_policy_attachment.cluster_autoscaler_attach
  ]
}
