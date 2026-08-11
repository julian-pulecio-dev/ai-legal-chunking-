locals {
  endpoints = {
    register = {
      dir       = "register"
      route_key = "POST /auth/register"
      protected = false
    }
    confirm = {
      dir       = "confirm"
      route_key = "POST /auth/confirm"
      protected = false
    }
    resend_confirmation = {
      dir       = "resend_confirmation"
      route_key = "POST /auth/resend-confirmation"
      protected = false
    }
    login = {
      dir       = "login"
      route_key = "POST /auth/login"
      protected = false
    }
    refresh = {
      dir       = "refresh"
      route_key = "POST /auth/refresh"
      protected = false
    }
    forgot_password = {
      dir       = "forgot_password"
      route_key = "POST /auth/forgot-password"
      protected = false
    }
    confirm_forgot_password = {
      dir       = "confirm_forgot_password"
      route_key = "POST /auth/confirm-forgot-password"
      protected = false
    }
    logout = {
      dir       = "logout"
      route_key = "POST /auth/logout"
      protected = false
    }
    me = {
      dir       = "me"
      route_key = "GET /auth/me"
      protected = true
    }
  }
}

module "api" {
  source = "../../resources/apigatewayv2_api"

  name               = var.name
  cors_allow_origins = var.cors_allow_origins
  tags               = var.tags
}

module "stage" {
  source = "../../resources/apigatewayv2_stage"

  api_id = module.api.id
  tags   = var.tags
}

module "authorizer" {
  source = "../../resources/apigatewayv2_authorizer"

  api_id   = module.api.id
  name     = "${var.name}-cognito-jwt"
  issuer   = "https://${var.user_pool_endpoint}"
  audience = [var.user_pool_client_id]
}

module "execution_role" {
  source = "../lambda_cognito_execution_role"

  name          = "${var.name}-lambda-role"
  user_pool_arn = var.user_pool_arn
  tags          = var.tags
}

module "endpoints" {
  source   = "../lambda_endpoint"
  for_each = local.endpoints

  function_name      = "${var.name}-${each.key}"
  source_dir         = "${var.lambdas_source_root}/${each.value.dir}"
  common_source_dir  = var.common_source_dir
  execution_role_arn = module.execution_role.role_arn
  api_id             = module.api.id
  api_execution_arn  = module.api.execution_arn
  route_key          = each.value.route_key
  authorization_type = each.value.protected ? "JWT" : "NONE"
  authorizer_id      = each.value.protected ? module.authorizer.id : null
  log_retention_days = var.log_retention_days
  tags               = var.tags

  environment_variables = {
    CLIENT_ID    = var.user_pool_client_id
    USER_POOL_ID = var.user_pool_id
  }
}
