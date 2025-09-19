locals {
  api_name = "api-${coalesce(var.api_name, random_id.api_short.hex)}-restapi"
  resources_map = { for r in var.resource_definitions : r.resource_path => r }
  created_resource_paths = [for r in var.resource_definitions : "/${r.resource_path}"]
}
