# SSM AMI lookup for EKS-optimized AMI (Amazon Linux 2)
data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${var.aws_eks_cluster_version}/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "${var.aws_eks_cluster_name}-lt-"
  image_id      = data.aws_ssm_parameter.eks_ami.value
  instance_type = var.node_instance_type

  user_data = base64encode(<<EOF
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
      encrypted   = var.enable_kms ? true : false
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
