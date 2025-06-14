output "s3_bucket_id" {
  description = "The name (ID) of the created S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "dynamodb_table_name" {
  description = "The name of the created DynamoDB table"
  value       = aws_dynamodb_table.this.name
}

output "dynamodb_table_arn" {
  description = "The ARN of the created DynamoDB table"
  value       = aws_dynamodb_table.this.arn
}