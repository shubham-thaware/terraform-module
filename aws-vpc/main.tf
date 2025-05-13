#Creating VPC 
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      Name = "${var.vpc_name}-${var.env}"
    },
    var.additional_tags
  )

}

#Creating Subnets 
resource "aws_subnet" "public-subnet-1" {
  vpc_id                                      = aws_vpc.vpc.id
  cidr_block                                  = var.public-subnet-cidr-1
  availability_zone                           = "us-east-1a"
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true
  tags = merge(
    {
      Name = "${var.vpc_name}-${var.env}-public-subnet-1"
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
      Name = "${var.vpc_name}-${var.env}-public-subnet-2"
    }
  )

}

resource "aws_subnet" "private-subnet-1" {
  vpc_id                                      = aws_vpc.vpc.id
  cidr_block                                  = var.private-subnet-cidr-1
  availability_zone                           = "us-east-1a"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = false
  tags = merge(
    {
      Name = "${var.vpc_name}-${var.env}-private-subnet-1"
    }
  )

}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                                      = aws_vpc.vpc.id
  cidr_block                                  = var.private-subnet-cidr-2
  availability_zone                           = "us-east-1b"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch                     = false
  tags = merge(
    {
      Name = "${var.vpc_name}-${var.env}-private-subnet-2"
    }
  )
}

#Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      Name = "${var.vpc_name}-${var.env}-igw"
    }
  )
}

resource "aws_internet_gateway_attachment" "igw-attachment-vpc" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.vpc.id

}

#Creating Nat Gateway
resource "aws_eip" "nat_eip" {
  tags = merge(
    {
      Name = "${var.vpc_name}-${var.env}-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-subnet-2.id
  tags = merge(
    {
      Name = "${var.vpc_name}-${var.env}-nat-gateway"
    }
  )
}

#Creating Route Tables
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-${var.env}-public-rtb"
    }
  )
}

resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

# Route Table Association with subnets
resource "aws_route_table_association" "public-rtb-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "public-rtb-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "private-rtb-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rtb.id
}

resource "aws_route_table_association" "private-rtb-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rtb.id
}
