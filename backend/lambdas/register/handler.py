from botocore.exceptions import ClientError

from cognito_client import (
    CLIENT_ID,
    error_response,
    get_client,
    missing_field_response,
    parse_body,
    response,
)


def lambda_handler(event, context):
    try:
        body = parse_body(event)
        email = body["email"]
        password = body["password"]
    except KeyError as exc:
        return missing_field_response(exc)

    try:
        result = get_client().sign_up(
            ClientId=CLIENT_ID,
            Username=email,
            Password=password,
            UserAttributes=[{"Name": "email", "Value": email}],
        )
    except ClientError as exc:
        return error_response(exc)

    return response(
        201,
        {
            "userSub": result["UserSub"],
            "userConfirmed": result["UserConfirmed"],
        },
    )
