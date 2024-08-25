# AWS VPC Module

## Description
This VPC module require following variables needs to be pass.

## Required variables for VPC
- #**env**# ---> (It should be Dev, Qa, Stage or Prod)
- #**vpc_name**# ---> (It should be any string value, default value is "my-vpc")
- #**vpc_cidr_block**# ---> (It should be any cidr value, default value is "10.0.0.0/16")
- #**additional_tags**# ---> (if you need add any additional tags then pas any string values)

### Example with variables for VPC
```
resource "aws_vpc" "vpc" {
    cidr_block       = var.vpc_cidr_block  ------> vpc_cidr_block = 192.168.0.0/16
    instance_tenancy = "default"
    enable_dns_hostnames = true

 tags = merge(
    {
      Name = "${var.env}-${var.vpc_name}" ------> env = dev  vpc_name = custome   
    },
    var.additional_tags
  )
  
}
```

## Required variables for Subnets

- #**public-subnet-cidr-1**# ---> (Required Public Subnet 1 CIDR, defualt name is '10.0.10.0/24')
- #**public-subnet-cidr-2**# ---> (Required Public Subnet 2 CIDR, defualt name is '10.0.30.0/24')
- #**private-subnet-cidr-1**# ---> (Required Public Subnet 1 CIDR, defualt name is '10.0.0.0/26')
- #**private-subnet-cidr-2**# ---> (Required Public Subnet 2 CIDR, defualt name is '10.0.1.0/26')

## Required variables for Route Tables



## Pre-define Output values for VPC as follows:
- VPC ID
- VPC ARN