from flask import request

from common.request import jsoned
from tss.api import app


@app.route("/ping", methods=["GET", "POST"])
@jsoned({"action": "ping"})
def ping():
    req = request.json
    if req.get("action") == "ping":
        return {"status": "pong"}
    else:
        return {"status": "invalid_action"}


@app.route("/create_task", methods=["POST"])
@jsoned({
    "action": "create_task",
    "user": "*",
    "task_id": "id", #generate by ewi backend
    "language": ["nvcc", "python.pycuda"],
    "compiler_args": ["*"],
    "program_args": ["*"],
    "source_code": "*",
    "source_hash": ""
})
def create_task():
    req = request.json
    #conn = get_mongo_connection()
    #user_tasks = conn.tasks.find({"user": req.user})
    #for task in user_tasks:
    #    if req.source_hash == task.source_hash:
    #    return {"status": "task_exists"}
    #    else:
    #        #some checks maybe
    #maybe form another dict and do some checks
    #conn.tasks.insert(req)
    #return {"status": "task_registered"}

    if req.get("action", False) == "create_task":
        return {
            "status": "task_registered",
            "user": req["user"],
            "task_id": req["task_id"]
        }
    else:
        return {"status": "invalid_action"}


@app.route("/task_info", methods=["POST"])
@jsoned({
    "action": "task_info",
    "user": "*",
    "task_id": "id"
})
def task_info():
    req = request.json
    #conn = get_mongo_connection()
    #task = conn.tasks.find_one({"task_id": req["task_id"]})
    #maybe alter something
    #if task:
    #    return {"status": "ok",
    #            "task_status": task["status"],
    #            ### other info}
    #else:
    #    return {"status": "error",
    #            "description": "task {0} not found".format(req["task_id"])}
    return {"status": "test_status"}


@app.route("/list_tasks", methods=["POST"])
@jsoned({
    "action": "list_tasks",
    "user": "*",
    "filter": ["done", "send", "fail"]
})
def list_tasks():
    req = request.json
    return {"status": "no_such_tasks"}
