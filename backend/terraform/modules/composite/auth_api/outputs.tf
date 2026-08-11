output "api_id" {
  value = module.api.id
}

output "api_endpoint" {
  value = module.api.api_endpoint
}

output "invoke_url" {
  value = module.stage.invoke_url
}

output "authorizer_id" {
  value = module.authorizer.id
}
