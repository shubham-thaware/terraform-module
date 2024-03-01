region              = "us-east-1"
env                 = "dev"
vpc_cidr            = "192.168.0.0/16"
public_subnet_cidr1 = "192.168.0.0/24"
public_subnet_cidr2 = "192.168.64.0/24"
private_subnet1     = "192.168.128.0/24"
private_subnet2     = "192.168.192.0/24"
instance-type       = "t2.micro"
port                = [80, 8080, 443, 9090, 9000]
key_name            = "mykey"
# image_name          = ["ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2*"]
#values for s3
bucketname = "enternamehere"
bucketenv =  "enterenvhere"