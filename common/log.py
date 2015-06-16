import os
import logging

def get_logger(name, to_sderr=False):
    if os.environ.get("C3_DEBUG_MODE", False):
        tmp_dir = "./tmp"
        try:
            os.mkdir(tmp_dir)
        except OSError as e:
            print(str(e))
    else:
        tmp_dir = "/var/log/c3"

    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    logger.propagate = False
    file_handler = logging.FileHandler(tmp_dir + "/" + name + ".log", "w")
    file_handler.setLevel(logging.DEBUG)
    logger.addHandler(file_handler)
    return logger, file_handler.stream.fileno()
