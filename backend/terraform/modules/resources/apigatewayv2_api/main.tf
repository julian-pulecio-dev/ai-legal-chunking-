resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  protocol_type = var.protocol_type

  cors_configuration {
    allow_origins = var.cors_allow_origins
    allow_methods = var.cors_allow_methods
    allow_headers = var.cors_allow_headers
  }

  tags = var.tags
}
