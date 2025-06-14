resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = var.bucket_acl

  tags = merge(var.tags, {
    "Name" = var.bucket_name
  })

  versioning {
    enabled = var.bucket_versioning
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.bucket_encryption_algorithm
      }
    }
  }

  # Best practice: Prevent accidental destruction in production
  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}

resource "aws_dynamodb_table" "this" {
  name         = var.dynamo_table_name
  billing_mode = var.dynamo_billing_mode
  hash_key     = var.dynamo_hash_key

  attribute {
    name = var.dynamo_hash_key
    type = var.dynamo_hash_key_type
  }

  tags = merge(var.tags, {
    "Name" = var.dynamo_table_name
  })

  point_in_time_recovery {
    enabled = var.dynamo_pitr_enabled
  }

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
}