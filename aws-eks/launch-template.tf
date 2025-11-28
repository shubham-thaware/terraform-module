locals {
  eks_version_parts = split(".", var.aws_eks_cluster_version)

  eks_major = tonumber(local.eks_version_parts[0])
  eks_minor = tonumber(local.eks_version_parts[1])

  use_al2023 = local.eks_major > 1 || (local.eks_major == 1 && local.eks_minor >= 33)
}

data "aws_ssm_parameter" "eks_ami" {
  name = local.use_al2023 ? "/aws/service/eks/optimized-ami/${var.aws_eks_cluster_version}/amazon-linux-2023/recommended/image_id" : "/aws/service/eks/optimized-ami/${var.aws_eks_cluster_version}/amazon-linux-2/recommended/image_id"
}


resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "${var.aws_eks_cluster_name}-lt-"
  image_id      = data.aws_ssm_parameter.eks_ami.value
  instance_type = var.node_instance_type

user_data = base64encode(local.use_al2023 ? <<EOF
#!/bin/bash
set -o xtrace

cat <<CONFIG > /etc/nodeadm/nodeadm-config.yaml
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${var.aws_eks_cluster_name}
    region: ${var.aws_region}
  kubelet:
    flags:
      - "--node-labels=role=worker,cluster=${var.aws_eks_cluster_name}"
CONFIG

nodeadm init
EOF
: <<EOF
#!/bin/bash
/etc/eks/bootstrap.sh ${var.aws_eks_cluster_name} \
  --kubelet-extra-args '--node-labels=role=worker,cluster=${var.aws_eks_cluster_name}'
EOF
)

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.node_volume_size
      volume_type = "gp3"
      encrypted   = var.enable_kms
      kms_key_id  = var.enable_kms ? aws_kms_key.cluster[0].arn : null
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.default_tags, {
      "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "owned"
    })
  }
}
