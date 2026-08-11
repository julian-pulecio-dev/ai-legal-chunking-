variable "name" {
  type = string
}

variable "protocol_type" {
  type    = string
  default = "HTTP"
}

variable "cors_allow_origins" {
  type    = list(string)
  default = ["*"]
}

variable "cors_allow_methods" {
  type    = list(string)
  default = ["GET", "POST", "OPTIONS"]
}

variable "cors_allow_headers" {
  type    = list(string)
  default = ["content-type", "authorization"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
