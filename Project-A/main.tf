

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

# #creating the ec2
module "ec2" {
  source        = "../modules/ec2"
  instance-type = var.instance-type
  ports         = var.port
  public-subnet = module.vpc.public_subnet_az1
  key           = file("${path.module}/id_rsa.pub")
  key_name      = var.key_name
  # image_name    = var.image_name

}

# #creating the s3

module "s3" {
  source      = "../modules/s3"
  bucketname = var.bucketname
  s3env       = var.env
}

# creating the rds

module "rds" {
  source                          = "../modules/rds"
  project                         = var.project
  environment                     = var.env
  size                            = "db.t3.medium"
  password                        = "supersecurepassword"
  subnets                         = ["subnet-00c3df48e8754b108", "subnet-02fe921ce95550977", "subnet-057e5fe13c10b7713"]
  amount_of_instances             = 1
  security_groups                 = [module.rds.rds_sg]
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]
} 