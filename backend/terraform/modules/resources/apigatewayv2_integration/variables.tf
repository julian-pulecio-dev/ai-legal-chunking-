variable "api_id" {
  type = string
}

variable "lambda_invoke_arn" {
  type = string
}

variable "payload_format_version" {
  type    = string
  default = "2.0"
}
