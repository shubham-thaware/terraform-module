

#This is the S3 bucket code
resource "aws_s3_bucket" "mys3" {

  bucket = "${var.bucketname}-s3bucket"


  tags = {
    Name        = "My_Bucket"
    Environment = var.s3env
    creation_date = timestamp()
    Iac = "terraform"
  }
}

#Versioning Enabled for s3
resource "aws_s3_bucket_versioning" "versionings3" {
    bucket = aws_s3_bucket.mys3.id
  versioning_configuration {
    status = "Enabled"
  }
  
}

#erver_side_encryption_configuration
resource "aws_kms_key" "mykms" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}


resource "aws_s3_bucket_server_side_encryption_configuration" "encrypts3" {
  bucket = aws_s3_bucket.mys3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}