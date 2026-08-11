module "cognito_auth" {
  source = "../cognito_auth"

  user_pool_name        = "${var.name}-user-pool"
  user_pool_client_name = "${var.name}-client"
  tags                  = var.tags
}

module "auth_api" {
  source = "../auth_api"

  name                = "${var.name}-auth-api"
  cors_allow_origins  = var.cors_allow_origins
  user_pool_id        = module.cognito_auth.user_pool_id
  user_pool_arn       = module.cognito_auth.user_pool_arn
  user_pool_endpoint  = module.cognito_auth.user_pool_endpoint
  user_pool_client_id = module.cognito_auth.user_pool_client_id
  lambdas_source_root = var.lambdas_source_root
  common_source_dir   = var.common_source_dir
  log_retention_days  = var.log_retention_days
  tags                = var.tags
}
