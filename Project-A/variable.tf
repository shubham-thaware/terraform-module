variable "region" {
  type = string

}
variable "vpc_cidr" {

}
variable "public_subnet_cidr1" {

}
variable "public_subnet_cidr2" {

}
variable "private_subnet1" {

}
variable "private_subnet2" {

}
variable "env" {
  description = "requires env name like dev, qa, stage & prod"
  type        = string
  default     = "Production"
}
variable "instance-type" {

}
variable "port" {

}
variable "key_name" {

}
# variable "image_name" {

# }

variable "bucketname" {
  description = "requires unique name for s3 bucket "
  type        = string
  default     = ""
}

variable "project" {
  description = "requires project name for rds"
  type        = string
  default     = "myproject"
}