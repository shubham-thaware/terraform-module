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

variable "additional_tags" {
  description = "Additional tags values are optional, pass as a map"
  type        = map(string)
  default = {
    Project = "project"
  }
}

#Subnet variables
variable "public-subnet-cidr-1" {
  description = "Required Public Subnet 1 CIDR, defualt name is '10.0.10.0/24'"
  default     = "10.0.10.0/24"
}

variable "public-subnet-cidr-2" {
  description = "Required Public Subnet 2 CIDR, defualt name is '10.0.30.0/24'"
  default     = "10.0.30.0/24"
}

variable "private-subnet-cidr-1" {
  description = "Required Public Subnet 1 CIDR, defualt name is '10.0.0.0/26'"
  default     = "10.0.0.0/26"
}

variable "private-subnet-cidr-2" {
  description = "Required Public Subnet 2 CIDR, defualt name is '10.0.1.0/26'"
  default     = "10.0.1.0/26"
}