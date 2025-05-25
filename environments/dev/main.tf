provider "aws" {
region = "us-east-1"
}
module "vpc" {
  source         = "../../aws-vpc"
  env            = var.env
  vpc_name       = var.vpc_name
  vpc_cidr_block = var.cidr_block
  additional_tags = {
    manage_by = "terraform"
  }
}
