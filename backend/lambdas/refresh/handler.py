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
        refresh_token = body["refreshToken"]
    except KeyError as exc:
        return missing_field_response(exc)

    try:
        result = get_client().initiate_auth(
            ClientId=CLIENT_ID,
            AuthFlow="REFRESH_TOKEN_AUTH",
            AuthParameters={"REFRESH_TOKEN": refresh_token},
        )
    except ClientError as exc:
        return error_response(exc)

    auth_result = result["AuthenticationResult"]
    return response(
        200,
        {
            "idToken": auth_result["IdToken"],
            "accessToken": auth_result["AccessToken"],
            "expiresIn": auth_result["ExpiresIn"],
        },
    )
