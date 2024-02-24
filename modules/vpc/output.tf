output "vpc-id" {
  value = aws_vpc.vpc.id
}
output "eip-details" {
    value = aws_eip.nat-eip.id
  
}
output "public_subnet_az1" {
  value = aws_subnet.public_subnet_az1.id
  
}
output "public_subnet_az2" {
  value = aws_subnet.public_subnet_az2.id
  
}