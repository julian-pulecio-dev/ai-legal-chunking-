module "user_pool" {
  source = "../../resources/cognito_user_pool"

  name = var.user_pool_name
  tags = var.tags
}

module "user_pool_client" {
  source = "../../resources/cognito_user_pool_client"

  name         = var.user_pool_client_name
  user_pool_id = module.user_pool.id
}
