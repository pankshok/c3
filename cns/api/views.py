from flask import request

from common.request import jsoned
from cns.api import app

@app.route("/ping", methods=["POST"])
@jsoned({"action": "ping"})
def ping():
    req = request.json
    if req.get("action", False) == "ping":
        return {"status": "pong"}
    else:
        return {"status": "invalid_action"}

@app.route("/create_task", methods=["POST"])
@jsoned({"action": "create_task",
         "language": ["nvcc", "python.pycuda"],
         "task_id": "id",
         "compiler_args": ["*"],
         "program_args": ["*"],
         "source_code": "*"})
def create_task():
    req = request.json
