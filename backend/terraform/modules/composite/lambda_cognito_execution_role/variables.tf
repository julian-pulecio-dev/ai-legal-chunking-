variable "name" {
  description = "Name of the shared IAM role"
  type        = string
}

variable "user_pool_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
