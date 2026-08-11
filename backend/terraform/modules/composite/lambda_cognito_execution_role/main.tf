module "role" {
  source = "../../resources/iam_role"

  name = var.name
  assume_role_policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

module "cognito_policy" {
  source = "../../resources/iam_role_policy"

  name    = "${var.name}-cognito-idp"
  role_id = module.role.id
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "cognito-idp:SignUp",
        "cognito-idp:ConfirmSignUp",
        "cognito-idp:ResendConfirmationCode",
        "cognito-idp:InitiateAuth",
        "cognito-idp:GlobalSignOut",
        "cognito-idp:ForgotPassword",
        "cognito-idp:ConfirmForgotPassword",
      ]
      Resource = var.user_pool_arn
    }]
  })
}

module "basic_execution_attachment" {
  source = "../../resources/iam_role_policy_attachment"

  role_name  = module.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
