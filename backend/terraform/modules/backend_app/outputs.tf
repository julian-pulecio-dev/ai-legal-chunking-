output "user_pool_id" {
  value = module.cognito_auth.user_pool_id
}

output "user_pool_client_id" {
  value = module.cognito_auth.user_pool_client_id
}

output "api_endpoint" {
  value = module.auth_api.api_endpoint
}

output "invoke_url" {
  value = module.auth_api.invoke_url
}
