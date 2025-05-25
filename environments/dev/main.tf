module "vpc" {
  source         = "../aws-vpc"
  env            = var.env
  vpc_name       = var.vpc_name
  vpc_cidr_block = var.cidr_block
}