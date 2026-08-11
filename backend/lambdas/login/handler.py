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
        result = get_client().initiate_auth(
            ClientId=CLIENT_ID,
            AuthFlow="USER_PASSWORD_AUTH",
            AuthParameters={"USERNAME": email, "PASSWORD": password},
        )
    except ClientError as exc:
        return error_response(exc)

    if "ChallengeName" in result:
        return response(
            200,
            {
                "challengeName": result["ChallengeName"],
                "session": result["Session"],
            },
        )

    auth_result = result["AuthenticationResult"]
    return response(
        200,
        {
            "idToken": auth_result["IdToken"],
            "accessToken": auth_result["AccessToken"],
            "refreshToken": auth_result["RefreshToken"],
            "expiresIn": auth_result["ExpiresIn"],
        },
    )
