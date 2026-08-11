locals {
  exclude_patterns = ["__pycache__", ".pyc"]

  handler_files = [
    for f in fileset(var.source_dir, "**") : f
    if !anytrue([for p in local.exclude_patterns : strcontains(f, p)])
  ]

  extra_files = var.extra_source_dir != null ? [
    for f in fileset(var.extra_source_dir, "**") : f
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
      content  = file("${var.extra_source_dir}/${source.value}")
      filename = source.value
    }
  }
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  role             = var.role_arn
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256

  environment {
    variables = var.environment_variables
  }

  tags = var.tags
}
