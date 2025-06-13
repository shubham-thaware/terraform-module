variable "env" {
  description = "Required env, defualt name is 'dev'"
  default     = "dev"
}

variable "vpc_name" {
  description = "Required VPC name to identify the vpc, defualt name is 'my-vpc'"
  default     = "my-vpc"

}

variable "vpc_cidr_block" {
  description = "Required VPC CIDR, defualt name is '10.0.0.0/16'"
  default     = "10.0.0.0/16"

}

#variable "additional_tags" {
 # description = "Additional tags values are optional, pass as a map"
  #type        = map(string)
#}

#Subnet variables
variable "public_subnet_cidr_1" {
  description = "Provide the CIDR block for public subnet 1"
  type        = string
}

variable "public_subnet_cidr_2" {
  description = "Provide the CIDR block for public subnet 2"
  type        = string
}

variable "private_subnet_cidr_1" {
  description = "Provide the CIDR block for private subnet 1"
  type        = string
}

variable "private_subnet_cidr_2" {
  description = "Provide the CIDR block for private subnet 2"
  type        = string
}
