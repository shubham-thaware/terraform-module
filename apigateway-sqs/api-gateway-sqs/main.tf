resource "random_id" "api_short" {
  byte_length = 4
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "this" {
  name        = local.api_name
  description = "Private REST API created by module"

  endpoint_configuration {
    types = ["PRIVATE"]
  }
  tags = var.tags
}

resource "aws_api_gateway_resource" "health" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "health"
}

resource "aws_api_gateway_method" "health_get" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.health.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "health_get_mock" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.health.id
  http_method = aws_api_gateway_method.health_get.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{\n  \"statusCode\": 200\n}"
  }

  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_resource" "user_resources" {
  for_each    = local.resources_map
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = each.key
}

resource "aws_api_gateway_method" "user_methods" {
  for_each      = local.resources_map
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.user_resources[each.key].id
  http_method   = upper(each.value.method)
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user_integrations" {
  for_each    = local.resources_map
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.user_resources[each.key].id
  http_method = aws_api_gateway_method.user_methods[each.key].http_method

  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.id}:sqs:path/${element(split(":", each.value.sqs_queue_arn), 4)}/${element(split(":", each.value.sqs_queue_arn), 5)}"
  credentials = each.value.iam_role_arn
  request_templates = {
    "application/json" = each.value.integration_template
  }
  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  passthrough_behavior = "WHEN_NO_MATCH"
}


resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.health.id,
      values(aws_api_gateway_resource.user_resources)[*].id,
      values(aws_api_gateway_method.user_methods)[*].id,
      values(aws_api_gateway_integration.user_integrations)[*].id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_api_gateway_stage" "this" {
  rest_api_id    = aws_api_gateway_rest_api.this.id
  deployment_id  = aws_api_gateway_deployment.this.id
  stage_name     = var.stage_name
  xray_tracing_enabled = false
}
# Attach a resource policy so the Private API can be deployed
resource "aws_api_gateway_rest_api_policy" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "execute-api:Invoke"
        Resource  = "arn:aws:execute-api:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.this.id}/*"
        Condition = {
          StringEquals = {
            "aws:SourceVpce" = var.vpc_endpoint_ids
          }
        }
      }
    ]
  })
}
