variable "api_id" {
  type = string
}

variable "name" {
  type    = string
  default = "$default"
}

variable "auto_deploy" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
