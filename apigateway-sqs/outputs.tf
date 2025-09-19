output "apigateway_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "api_endpoint_url" {
  value = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${var.stage_name}"
}

output "created_resource_paths" {
  value = local.created_resource_paths
}

output "stage_name" {
  value = var.stage_name
}
