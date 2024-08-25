#VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = "${var.env}-${var.vpc_name}"
    },
    var.additional_tags
  )

}

#Subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id                                      = aws_vpc.vpc.id
  cidr_block                                  = var.public-subnet-cidr-1
  availability_zone                           = "us-east-1a"
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true
  tags = merge(
    {
      Name = "${var.env}-public-subnet-1"
    }
  )

}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                                      = aws_vpc.vpc.id
  cidr_block                                  = var.public-subnet-cidr-2
  availability_zone                           = "us-east-1b"
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true
  tags = merge(
    {
      Name = "${var.env}-public-subnet-2"
    }
  )

}

resource "aws_subnet" "private-subnet-1" {
  vpc_id                                      = aws_vpc.vpc.id
  cidr_block                                  = var.private-subnet-cidr-1
  availability_zone                           = "us-east-1a"
  enable_resource_name_dns_a_record_on_launch = true
  tags = merge(
    {
      Name = "${var.env}-private-subnet-1"
    }
  )

}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                                      = aws_vpc.vpc.id
  cidr_block                                  = var.private-subnet-cidr-2
  availability_zone                           = "us-east-1b"
  enable_resource_name_dns_a_record_on_launch = true
  tags = merge(
    {
      Name = "${var.env}-private-subnet-2"
    }
  )
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${var.env}-igw"
    }
  )
}

resource "aws_internet_gateway_attachment" "igw-attachment-vpc" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.vpc.id
}


provider "aws" {

}