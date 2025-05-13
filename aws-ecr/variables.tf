variable "ecr_repo_name" {
    description = "AWS ECR Repo Name"
    type = string
}

variable "ecr_repo_env" {
    description = "AWS ECR Repo Environment"
    type = string
    default = "Dev"
}

variable "iam_role_arn" {
  description = "IAM role ARN with access to ECR (optional)"
  type        = string
  default     = ""
}