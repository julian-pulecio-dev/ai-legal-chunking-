variable "api_id" {
  type = string
}

variable "name" {
  type = string
}

variable "issuer" {
  description = "Cognito user pool issuer URL, e.g. https://cognito-idp.<region>.amazonaws.com/<pool_id>"
  type        = string
}

variable "audience" {
  description = "Allowed audiences (Cognito app client IDs)"
  type        = list(string)
}

variable "identity_source" {
  type    = list(string)
  default = ["$request.header.Authorization"]
}
