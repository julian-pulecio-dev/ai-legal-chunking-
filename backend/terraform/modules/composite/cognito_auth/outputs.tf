output "user_pool_id" {
  value = module.user_pool.id
}

output "user_pool_arn" {
  value = module.user_pool.arn
}

output "user_pool_endpoint" {
  value = module.user_pool.endpoint
}

output "user_pool_client_id" {
  value = module.user_pool_client.id
}
