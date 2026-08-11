import base64
import json
import os

import boto3
from botocore.exceptions import ClientError

CLIENT_ID = os.environ.get("CLIENT_ID")
USER_POOL_ID = os.environ.get("USER_POOL_ID")

_client = boto3.client("cognito-idp")

CORS_HEADERS = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "content-type,authorization",
    "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
}

# Cognito's ClientError.Error.Code -> HTTP status code for this API's responses.
_ERROR_STATUS = {
    "UsernameExistsException": 409,
    "UserNotFoundException": 404,
    "NotAuthorizedException": 401,
    "UserNotConfirmedException": 403,
    "CodeMismatchException": 400,
    "ExpiredCodeException": 400,
    "InvalidPasswordException": 400,
    "InvalidParameterException": 400,
    "TooManyFailedAttemptsException": 429,
    "LimitExceededException": 429,
    "TooManyRequestsException": 429,
}


def get_client():
    return _client


def parse_body(event):
    raw = event.get("body") or "{}"
    if event.get("isBase64Encoded"):
        raw = base64.b64decode(raw).decode("utf-8")
    return json.loads(raw)


def response(status_code, body):
    return {
        "statusCode": status_code,
        "headers": CORS_HEADERS,
        "body": json.dumps(body),
    }


def error_response(exc):
    if isinstance(exc, ClientError):
        code = exc.response["Error"]["Code"]
        message = exc.response["Error"]["Message"]
        status = _ERROR_STATUS.get(code, 400)
        return response(status, {"error": code, "message": message})
    return response(500, {"error": "InternalError", "message": str(exc)})


def missing_field_response(exc):
    return response(400, {"error": "InvalidRequest", "message": f"missing field {exc}"})
