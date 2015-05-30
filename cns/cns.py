"""Computing node service"""

import os
import sys
import time

from daemonize import Daemonize

from common import log

SERVICE = "ncs"

tmp = "/tmp/c3"
pid = tmp + "/{0}.pid".format(SERVICE)
logger, log_fd = log.get_logger(SERVICE)


def work():
    while True:
        time.sleep(3)
        logger.debug("pshoo")


def main():
    pid_aquired = False
    try:
        try:
            os.mkdir(tmp)
            pid_aquired = True
        except Exception as e:
            logger.exception("Service {0} has crashed during initialization.".format(SERVICE))

        try:
            daemon = Daemonize(app="c3_{0}".format(SERVICE), pid=pid, action=work, keep_fds=[log_fd])
            daemon.start()
        except Exception as e:
            logger.exception("Service {0} has crashed during daemonizing.".format(SERVICE))
    finally:
        if pid_aquired:
            try:
                os.unlink(pid)
            except Exception as e:
                logger.error("Unable to remove PID file '{0}'.".format(pid))
        sys.exit(0)

if __name__ == "__main__":
    main()
