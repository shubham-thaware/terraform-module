# creating ssh-key.
resource "aws_key_pair" "key-tf" {
  key_name   = var.key_name
  public_key = var.key

}