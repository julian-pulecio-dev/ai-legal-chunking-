moved {
  from = module.role.aws_iam_role.this
  to   = aws_iam_role.this
}

moved {
  from = module.cognito_policy.aws_iam_role_policy.this
  to   = aws_iam_role_policy.this
}

moved {
  from = module.basic_execution_attachment.aws_iam_role_policy_attachment.this
  to   = aws_iam_role_policy_attachment.this
}

resource "aws_iam_role" "this" {
  name = var.name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "this" {
  name = "${var.name}-cognito-idp"
  role = aws_iam_role.this.id
  policy = jsonencode({
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

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
