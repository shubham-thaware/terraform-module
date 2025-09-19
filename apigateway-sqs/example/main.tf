provider "aws" {
  region = "us-east-1"
}

module "private_api" {
  source = "../api-gateway-sqs"

  api_name         = var.api_name
  stage_name       = var.stage_name
  vpc_endpoint_ids = var.vpc_endpoint_ids

  resource_definitions = [
    {
      resource_path        = ""
      method               = "POST"
      integration_template = "#set($inputRoot = $input.path('$')) { \"Action\": \"SendMessage\", \"MessageBody\": \"$util.urlEncode($input.json('$'))\" }"
      sqs_queue_arn        = ""
      iam_role_arn         = ""
    },
    {
      resource_path        = ""
      method               = "POST"
      integration_template = "#set($inputRoot = $input.path('$')) { \"Action\": \"SendMessage\", \"MessageBody\": \"$util.urlEncode($input.json('$'))\" }"
      sqs_queue_arn        = ""
      iam_role_arn         = ""
    },
    {
      resource_path        = ""
      method               = "POST"
      integration_template = "#set($inputRoot = $input.path('$')) { \"Action\": \"SendMessage\", \"MessageBody\": \"$util.urlEncode($input.json('$'))\" }"
      sqs_queue_arn        = ""
      iam_role_arn         = ""
    }
  ]

  tags = var.tags
}
