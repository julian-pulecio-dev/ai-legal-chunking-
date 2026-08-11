resource "aws_apigatewayv2_stage" "this" {
  api_id      = var.api_id
  name        = var.name
  auto_deploy = var.auto_deploy
  tags        = var.tags
}
