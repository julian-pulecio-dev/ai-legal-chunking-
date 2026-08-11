variable "name" {
  description = "Name of the IAM role"
  type        = string
}

variable "assume_role_policy_json" {
  description = "JSON assume role policy document"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
