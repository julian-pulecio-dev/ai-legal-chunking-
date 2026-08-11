moved {
  from = module.log_group.aws_cloudwatch_log_group.this
  to   = aws_cloudwatch_log_group.this
}

moved {
  from = module.function.aws_lambda_function.this
  to   = aws_lambda_function.this
}

moved {
  from = module.invoke_permission.aws_lambda_permission.this
  to   = aws_lambda_permission.this
}

moved {
  from = module.integration.aws_apigatewayv2_integration.this
  to   = aws_apigatewayv2_integration.this
}

moved {
  from = module.route.aws_apigatewayv2_route.this
  to   = aws_apigatewayv2_route.this
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

locals {
  exclude_patterns = ["__pycache__", ".pyc"]

  handler_files = [
    for f in fileset(var.source_dir, "**") : f
    if !anytrue([for p in local.exclude_patterns : strcontains(f, p)])
  ]

  extra_files = var.common_source_dir != null ? [
    for f in fileset(var.common_source_dir, "**") : f
    if !anytrue([for p in local.exclude_patterns : strcontains(f, p)])
  ] : []
}

data "archive_file" "this" {
  type        = "zip"
  output_path = "${path.module}/.build/${var.function_name}.zip"

  dynamic "source" {
    for_each = local.handler_files
    content {
      content  = file("${var.source_dir}/${source.value}")
      filename = source.value
    }
  }

  dynamic "source" {
    for_each = local.extra_files
    content {
      content  = file("${var.common_source_dir}/${source.value}")
      filename = source.value
    }
  }
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  role             = var.execution_role_arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.12"
  timeout          = 10
  memory_size      = 128
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256

  environment {
    variables = var.environment_variables
  }

  tags = var.tags
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "this" {
  api_id                 = var.api_id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.this.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "this" {
  api_id             = var.api_id
  route_key          = var.route_key
  target             = "integrations/${aws_apigatewayv2_integration.this.id}"
  authorization_type = var.authorization_type
  authorizer_id      = var.authorizer_id
}
