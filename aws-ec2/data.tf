data "aws_ami" "latest_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-20.04-amd64-server-*"]
  }

  owners = ["amazon"] # Specify the AMI owner (Amazon, Self, etc.)
}
