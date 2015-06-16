"""Task sheduling service"""

from common import log
from tss.api import app

SERVICE = "tss"

logger, log_fd = log.get_logger(SERVICE)


def manage():
    from flask.ext.script import Manager

    manager = Manager(app)
    manager.run()
