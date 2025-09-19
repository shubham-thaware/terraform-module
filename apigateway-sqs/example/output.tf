output "api_id" {
  value = module.private_api.apigateway_id
}

output "api_url" {
  value = module.private_api.api_endpoint_url
}

output "resources" {
  value = module.private_api.created_resource_paths
}
