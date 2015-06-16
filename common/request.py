import http
import json
from functools import wraps

from flask import jsonify, request

from common.config import config


def validate(request, template):
    pass

def jsoned(template):
    """Automatically convert dictionary to JSON"""

    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            content_length = request.content_length
            if not isinstance(content_length, int) or content_length > config.MAX_REQUEST_SIZE:
                raise Exception("Request is too large")

            validate(request.json, template)
            ctx = f(*args, **kwargs)
            if ctx is None:
                ctx = {}
            elif not isinstance(ctx, dict):
                return ctx
            return jsonify(**ctx)

        return decorated_function

    return decorator

def send_request(url, route, data, headers={"Content-type": "application/json"}):
    data = json.dumps(data)
    conn = http.client.HTTPConnection(url)
    conn.request("POST", route, data, headers)
    resp = conn.getresponse()
    return json.loads(resp.read())
