variable "name" {
  type = string
}

variable "cors_allow_origins" {
  type    = list(string)
  default = ["*"]
}

variable "user_pool_id" {
  type = string
}

variable "user_pool_arn" {
  type = string
}

variable "user_pool_endpoint" {
  description = "Cognito user pool endpoint host, e.g. cognito-idp.us-east-1.amazonaws.com/us-east-1_xxxx"
  type        = string
}

variable "user_pool_client_id" {
  type = string
}

variable "lambdas_source_root" {
  description = "Path to backend/lambdas, containing one directory per handler"
  type        = string
}

variable "common_source_dir" {
  description = "Path to backend/lambdas/common, flattened into every function's zip"
  type        = string
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "tags" {
  type    = map(string)
  default = {}
}
