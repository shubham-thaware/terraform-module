provider "aws" {
  region     = var.region
  access_key = "enter_your_access_key"
  secret_key = "enter_your_secret_key"
}

#creating the vpc
module "vpc" {
  source              = "../modules/vpc"
  region              = var.region
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr1 = var.public_subnet_cidr1
  public_subnet_cidr2 = var.public_subnet_cidr2
  private_subnet1     = var.private_subnet1
  private_subnet2     = var.private_subnet2

}

#creating the ec2
module "ec2" {
  source        = "../modules/ec2"
  instance-type = var.instance-type
  ports         = var.port
  public-subnet = module.vpc.public_subnet_az1
  key           = file("${path.module}/id_rsa.pub")
  key_name      = var.key_name
  # image_name    = var.image_name

}