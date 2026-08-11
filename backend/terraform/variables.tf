variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  description = "Base name used to derive resource names"
  type        = string
  default     = "ai-legal-chunking-dev"
}

variable "cors_allow_origins" {
  description = "Origins allowed to call the auth API (e.g. the React dev server / deployed frontend URL)"
  type        = list(string)
  default     = ["http://localhost:5173"]
}

variable "tags" {
  type = map(string)
  default = {
    Project     = "ai-legal-chunking"
    ManagedBy   = "terraform"
    Environment = "dev"
  }
}
