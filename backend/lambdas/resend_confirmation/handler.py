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
    except KeyError as exc:
        return missing_field_response(exc)

    try:
        get_client().resend_confirmation_code(
            ClientId=CLIENT_ID,
            Username=email,
        )
    except ClientError as exc:
        return error_response(exc)

    return response(200, {"message": "confirmation code resent"})
