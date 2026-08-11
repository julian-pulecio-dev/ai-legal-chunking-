variable "name" {
  description = "Name of the inline policy"
  type        = string
}

variable "role_id" {
  description = "ID of the IAM role this policy is attached to"
  type        = string
}

variable "policy_json" {
  description = "JSON policy document"
  type        = string
}
