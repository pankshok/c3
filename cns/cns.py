"""Computing node service"""

from common import log
from cns.api import app

SERVICE = "cns"

logger, log_fd = log.get_logger(SERVICE)


def manage():
    from flask.ext.script import Manager

    manager = Manager(app)
    manager.run()
