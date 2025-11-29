variable "aws_region" {
  type = string
   default = "us-east-1"
}

variable "aws_eks_cluster_name" {
  type = string
}

variable "aws_eks_cluster_version" {
  type    = string
  default = "1.29"
}

variable "default_tags" {
  type = map(string)
  default = {
    Environment = "production"
  }
}

variable "vpc_id" {
  type = string
}

variable "aws_vpc_private_subnet_ids" {
  type = list(string)
}

variable "aws_eks_cluster_sg_ids" {
  type = list(string)
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "Allowed CIDRs for EKS API public endpoint"
  type        = list(string)
  default = ["0.0.0.0/0"]
}

variable "eks_endpoint_private_access" {
  type    = bool
  default = true
}

variable "eks_endpoint_public_access" {
  type    = bool
  default = false
}

variable "control_plane_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator"]
}

variable "enable_kms" {
  type    = bool
  default = false
}


variable "node_labels" {
  type    = map(string)
  default = {}
}


variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "node_volume_size" {
  type    = number
  default = 20
}

variable "node_desired" {
  type    = number
  default = 2
}

variable "node_min" {
  type    = number
  default = 1
}

variable "node_max" {
  type    = number
  default = 4
}


variable "create_spot_node_group" {
  type    = bool
  default = false
}

variable "spot_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "spot_desired_size" {
  type    = number
  default = 0
}

variable "spot_min_size" {
  type    = number
  default = 0
}

variable "spot_max_size" {
  type    = number
  default = 0
}
variable "authentication_mode" {
  type    = string
  default = "API_AND_CONFIG_MAP"
}

