variable "function_name" {
  type = string
}

variable "source_dir" {
  description = "Directory containing the handler's own source files"
  type        = string
}

variable "extra_source_dir" {
  description = "Optional directory whose files are flattened into the zip root alongside the handler (e.g. shared code)"
  type        = string
  default     = null
}

variable "handler" {
  type    = string
  default = "handler.lambda_handler"
}

variable "runtime" {
  type    = string
  default = "python3.12"
}

variable "role_arn" {
  type = string
}

variable "timeout" {
  type    = number
  default = 10
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
