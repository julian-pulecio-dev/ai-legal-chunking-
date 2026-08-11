variable "name" {
  description = "Name of the user pool client"
  type        = string
}

variable "user_pool_id" {
  type = string
}

variable "explicit_auth_flows" {
  type    = list(string)
  default = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}

variable "generate_secret" {
  type    = bool
  default = false
}

variable "access_token_validity_minutes" {
  type    = number
  default = 60
}

variable "id_token_validity_minutes" {
  type    = number
  default = 60
}

variable "refresh_token_validity_days" {
  type    = number
  default = 30
}
