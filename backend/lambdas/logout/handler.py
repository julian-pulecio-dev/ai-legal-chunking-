from botocore.exceptions import ClientError

from cognito_client import (
    error_response,
    get_client,
    missing_field_response,
    parse_body,
    response,
)


def lambda_handler(event, context):
    try:
        body = parse_body(event)
        access_token = body["accessToken"]
    except KeyError as exc:
        return missing_field_response(exc)

    try:
        get_client().global_sign_out(AccessToken=access_token)
    except ClientError as exc:
        return error_response(exc)

    return response(200, {"message": "signed out"})
