resource "aws_apigatewayv2_authorizer" "this" {
  api_id           = var.api_id
  authorizer_type  = "JWT"
  identity_sources = var.identity_source
  name             = var.name

  jwt_configuration {
    audience = var.audience
    issuer   = var.issuer
  }
}
