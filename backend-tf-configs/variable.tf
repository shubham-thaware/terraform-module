variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "bucket_acl" {
  description = "The ACL applied to the S3 bucket"
  type        = string
  default     = "private"
}

variable "bucket_versioning" {
  description = "Enable versioning for the S3 bucket (true/false)"
  type        = bool
  default     = false
}

variable "bucket_encryption_algorithm" {
  description = "Encryption algorithm for S3 bucket (e.g., AES256, aws:kms)"
  type        = string
  default     = "AES256"
}

variable "dynamo_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "dynamo_hash_key" {
  description = "Hash key (partition key) for the DynamoDB table"
  type        = string
}

variable "dynamo_hash_key_type" {
  description = "Type for the DynamoDB hash key attribute; valid values: S (string), N (number), or B (binary)"
  type        = string
  default     = "S"
}

variable "dynamo_billing_mode" {
  description = "Billing mode for the DynamoDB table (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamo_pitr_enabled" {
  description = "Enable point in time recovery for the DynamoDB table"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of key/value tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "prevent_destroy" {
  description = "Whether to prevent accidental destruction of the resources"
  type        = bool
  default     = false
}