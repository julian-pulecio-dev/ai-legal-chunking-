output "api_base_url" {
  value = module.backend_app.invoke_url
}

output "user_pool_id" {
  value = module.backend_app.user_pool_id
}

output "user_pool_client_id" {
  value = module.backend_app.user_pool_client_id
}
