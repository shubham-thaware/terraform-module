output "vpc_id" {
  value = aws_vpc.vpc.id

}

output "vpc_arn" {
  value = aws_vpc.vpc.arn

}

output "public-subnet-1-id" {
  value = aws_subnet.public-subnet-1.id
}

output "public-subnet-2-id" {
    value = aws_subnet.public-subnet-2.id
}

output "private-subnet-1-id" {
  value = aws_subnet.private-subnet-1.id
}

output "private-subnet-2-id" {
  value = aws_subnet.private-subnet-2.id
}