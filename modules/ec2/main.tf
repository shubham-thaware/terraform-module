
#EC2
resource "aws_instance" "server" {
    subnet_id = var.public-subnet
    ami = data.aws_ami.server_ami.id
    instance_type = var.instance-type
    key_name = aws_key_pair.key-tf.key_name
    vpc_security_group_ids = ["{aws_security_group.security.id}"]
    tags = {
        Name = "{var.server-name}-server"
    }
  
}

# data block for ami
data "aws_ami" "server_ami" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}
# security group
# creating security group
resource "aws_security_group" "security" {
  name        = "security-group"
  description = "Allow TLS inbound traffic"
  dynamic "ingress" {
    for_each = var.ports#[80,8080,443,9090,9000]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}