resource "aws_cognito_user_pool_client" "this" {
  name         = var.name
  user_pool_id = var.user_pool_id

  explicit_auth_flows = var.explicit_auth_flows
  generate_secret     = var.generate_secret

  access_token_validity  = var.access_token_validity_minutes
  id_token_validity      = var.id_token_validity_minutes
  refresh_token_validity = var.refresh_token_validity_days

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  prevent_user_existence_errors = "ENABLED"
}
