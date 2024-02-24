#This is the VPC module 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-vpc"
  }
}


#This is the IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "{var.env}-igw"
  }

}

#Data block for to get all avalablility zones in region
data "aws_availability_zones" "available" {
  state = "available"
}

# This is the public subnet 1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr1
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "{var.env}-public-subnet1"
  }
}

# This is the public subnet 2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr2
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "{var.env}-public-subnet2"
  }
}

#This the route table
resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

#This is the subnet association for public subnet1
resource "aws_route_table_association" "pb-subnet1-rtb-association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.route-table.id
}

#This is the subnet association for public subnet2
resource "aws_route_table_association" "pb-subnet2-rtb-association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.route-table.id
}

#This is the private subnet1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[2]
  cidr_block              = var.private_subnet1
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-private-subnet1"
  }
}

#This is the private subnet2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[3]
  cidr_block              = var.private_subnet2
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-private-subnet2"
  }
}

#creating EIP for NAT Gateway
resource "aws_eip" "nat-eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "{var.env}-eip"
  }
}

#creating the NAT Gateway 
resource "aws_nat_gateway" "natgateway" {
  subnet_id  = aws_subnet.private_subnet_az1.id
  allocation_id = aws_eip.nat-eip.id
  depends_on = [aws_eip.nat-eip]
  tags = {
    Name = "{var.env}-natgatway"
  }
}

#creating the route table for NAT gatway
resource "aws_route_table" "route-nat" {
  vpc_id     = aws_vpc.vpc.id
  #depends_on = aws_nat_gateway.natgatway.id
  route {
    cidr_block = "0.0.0.0"
    gateway_id = aws_nat_gateway.natgateway.id
  }
  tags = {
    Name = "priavte-route-table"
  }
}

#Creating route table asscoiate with private subnet1 
resource "aws_route_table_association" "prvt-subnet1-rtb-association" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.route-nat.id

}

#Creating route table asscoiate with private subnet2 
resource "aws_route_table_association" "prvt-subnet2-rtb-association" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.route-nat.id

}