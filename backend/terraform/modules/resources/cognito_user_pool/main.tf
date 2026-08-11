resource "aws_cognito_user_pool" "this" {
  name = var.name

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = var.minimum_password_length
    require_lowercase = var.require_lowercase
    require_uppercase = var.require_uppercase
    require_numbers   = var.require_numbers
    require_symbols   = var.require_symbols
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  tags = var.tags
}
