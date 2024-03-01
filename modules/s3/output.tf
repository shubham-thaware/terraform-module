output "s3_bucket_name" {
    description = "This will output the s3 bucket name"
    value = aws_s3_bucket.mys3.id
  
}

output "s3_bucket_arn" {
    description = "This will output the s3 bucket arn"
    value = aws_s3_bucket.mys3.arn
  
}