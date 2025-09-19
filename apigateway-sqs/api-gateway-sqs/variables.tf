variable "stage_name" {
  description = "Name of the stage to create"
  type        = string
}

variable "api_name" {
  description = "Optional API Gateway name"
  type        = string
  default     = null
}

variable "resource_definitions" {
  description = <<EOF
A list of resource definitions. Each item must be an object with keys:
- resource_path      : string (no leading slash, single path-segment)
- method             : string (e.g. POST, PUT)
- integration_template: string (mapping template — plain string)
- sqs_queue_arn      : string (ARN of the SQS queue)
- iam_role_arn       : string (IAM role ARN for API Gateway to assume)
EOF
  type = list(object({
    resource_path        = string
    method               = string
    integration_template = string
    sqs_queue_arn        = string
    iam_role_arn         = string
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.resource_definitions : can(regex("^arn:aws:iam::", r.iam_role_arn))])
    error_message = "Each resource must include a valid iam_role_arn."
  }
}

variable "iam_role_arn" {
  description = "IAM role ARN that API Gateway will assume to send messages to SQS (optional if per-resource IAM is used)"
  type        = string
  default     = null
}


variable "vpc_endpoint_ids" {
  description = "List of VPC Endpoint IDs (interface) to attach to the PRIVATE API. Leave empty if you will attach later. For private APIs, you need at least one VPC endpoint."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Optional tags"
  type        = map(string)
  default     = {}
}
