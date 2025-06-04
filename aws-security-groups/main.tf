locals {
 sg_names = {
    "sg1" = "bastion-security-group"
    "sg2" = "database-security-group"
 } 

}

resource "aws_security_group" "bastion-sg" {
  name        = local.sg_map["sg1"]
  description = "Allow TLS inbound traffic and all outbound traffic for bastion security group"
  vpc_id      = var.vpc_id
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.sg_map["sg1"]
  }
  
}


resource "aws_security_group" "database-sg" {
  name        = local.sg_map["sg2"]
  description = "Allow TLS inbound traffic and all outbound traffic for database security group"
  vpc_id      = var.vpc_id
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.sg_map["sg2"]
  }
  
}

resource "aws_security_group" "eks_cluster" {
  name        = "${aws_eks_cluster_name}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${aws_eks_cluster_name}-eks-sg"
  }
}
