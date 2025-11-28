############################################
# How to CALL THIS AWS EKS Module with tfvar 
############################################

aws_region = "ap-south-1"

aws_eks_cluster_name    = "prod-eks-cluster"
aws_eks_cluster_version = "1.29"

##############################
# Networking
##############################

vpc_id = "vpc-xxxxxxxx"

aws_vpc_private_subnet_ids = [
  "subnet-aaaaaaaa",
  "subnet-bbbbbbbb",
  "subnet-cccccccc"
]

aws_eks_cluster_sg_ids = [
  "sg-xxxxxxxx"
]

cluster_endpoint_public_access_cidrs = [
  "YOUR_PUBLIC_IP/32"
]

eks_endpoint_private_access = true
eks_endpoint_public_access  = false

##############################
# Tags
##############################

default_tags = {
  Environment = "production"
  Owner       = "devops"
  Project     = "eks-infra"
}

##############################
# Node Group Config
##############################

node_instance_type = "t3.medium"
node_volume_size   = 20

node_desired = 2
node_min     = 1
node_max     = 4

##############################
# Spot Node Group (Optional)
##############################

create_spot_node_group = false

spot_instance_types = [
  "t3.small",
  "t3.medium"
]

spot_desired_size = 1
spot_min_size     = 0
spot_max_size     = 3

##############################
# Node Labels
##############################

node_labels = {
  role = "worker"
  env  = "production"
}

##############################
# Logging
##############################

control_plane_log_types = [
  "api",
  "audit",
  "authenticator"
]

##############################
# KMS
##############################

enable_kms = false

##############################
# EBS CSI Driver
##############################

ebs_csi_version = "v1.31.0-eksbuild.1"
