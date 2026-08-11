variable "statement_id" {
  type = string
}

variable "function_name" {
  type = string
}

variable "source_arn" {
  description = "API Gateway execution ARN allowed to invoke the function"
  type        = string
}
