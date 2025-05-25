resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_ami.id
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.bastion_sg_id]

  tags = {
    Name = "Bastion-Server"
  }
}

resource "aws_instance" "database" {
  ami                         = data.aws_ami.latest_ami.id
  instance_type               = var.db_instance_type
  subnet_id                   = var.private_subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [var.db_sg_id]

  tags = {
    Name = "Mango-DB"
  }
}