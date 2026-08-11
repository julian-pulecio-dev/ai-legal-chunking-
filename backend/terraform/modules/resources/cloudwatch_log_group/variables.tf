variable "name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "retention_in_days" {
  type    = number
  default = 14
}

variable "tags" {
  type    = map(string)
  default = {}
}
