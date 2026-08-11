output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "route_id" {
  value = aws_apigatewayv2_route.this.id
}
