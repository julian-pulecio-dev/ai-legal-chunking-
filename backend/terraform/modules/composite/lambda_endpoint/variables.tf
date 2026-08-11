variable "function_name" {
  type = string
}

variable "source_dir" {
  type = string
}

variable "common_source_dir" {
  type    = string
  default = null
}

variable "execution_role_arn" {
  type = string
}

variable "api_id" {
  type = string
}

variable "api_execution_arn" {
  type = string
}

variable "route_key" {
  type = string
}

variable "authorization_type" {
  type    = string
  default = "NONE"
}

variable "authorizer_id" {
  type    = string
  default = null
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "tags" {
  type    = map(string)
  default = {}
}
