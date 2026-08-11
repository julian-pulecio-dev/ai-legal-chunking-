variable "name" {
  description = "Base name used to derive resource names (e.g. \"legal-chunking-dev\")"
  type        = string
}

variable "cors_allow_origins" {
  type    = list(string)
  default = ["*"]
}

variable "lambdas_source_root" {
  type = string
}

variable "common_source_dir" {
  type = string
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "tags" {
  type    = map(string)
  default = {}
}
