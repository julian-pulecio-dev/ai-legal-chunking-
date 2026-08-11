from cognito_client import response


def lambda_handler(event, context):
    claims = event["requestContext"]["authorizer"]["jwt"]["claims"]
    return response(
        200,
        {
            "sub": claims.get("sub"),
            "email": claims.get("email"),
        },
    )
