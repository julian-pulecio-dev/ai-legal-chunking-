variable "api_id" {
  type = string
}

variable "route_key" {
  description = "e.g. \"POST /auth/login\""
  type        = string
}

variable "target" {
  description = "e.g. \"integrations/<integration_id>\""
  type        = string
}

variable "authorization_type" {
  type    = string
  default = "NONE"
}

variable "authorizer_id" {
  type    = string
  default = null
}
