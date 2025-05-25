terraform {
  backend "s3" {
    bucket         = "ci-cd-terraform-state"      # replace with your S3 bucket
    key            = "dev/vpc/terraform.tfstate"       # unique key per env/module
    region         = "us-east-1"                       # your AWS region
    dynamodb_table = "terraform-locks"                 # must exist in S3
    encrypt        = true
  }
}
