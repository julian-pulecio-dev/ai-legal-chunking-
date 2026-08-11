module "log_group" {
  source = "../../resources/cloudwatch_log_group"

  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

module "function" {
  source = "../../resources/lambda_function"

  function_name         = var.function_name
  source_dir            = var.source_dir
  extra_source_dir      = var.common_source_dir
  role_arn              = var.execution_role_arn
  environment_variables = var.environment_variables
  tags                  = var.tags
}

module "invoke_permission" {
  source = "../../resources/lambda_permission"

  statement_id  = "AllowAPIGatewayInvoke"
  function_name = module.function.function_name
  source_arn    = "${var.api_execution_arn}/*/*"
}

module "integration" {
  source = "../../resources/apigatewayv2_integration"

  api_id            = var.api_id
  lambda_invoke_arn = module.function.invoke_arn
}

module "route" {
  source = "../../resources/apigatewayv2_route"

  api_id             = var.api_id
  route_key          = var.route_key
  target             = module.integration.id
  authorization_type = var.authorization_type
  authorizer_id      = var.authorizer_id
}
