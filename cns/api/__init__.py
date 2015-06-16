from flask import Flask


app = Flask(__name__)
app.config.from_object("common.config.DevelopmentConfig")

from cns.api import views
