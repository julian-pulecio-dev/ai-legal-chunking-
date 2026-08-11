variable "name" {
  description = "Name of the Cognito user pool"
  type        = string
}

variable "minimum_password_length" {
  type    = number
  default = 8
}

variable "require_lowercase" {
  type    = bool
  default = true
}

variable "require_uppercase" {
  type    = bool
  default = true
}

variable "require_numbers" {
  type    = bool
  default = true
}

variable "require_symbols" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
