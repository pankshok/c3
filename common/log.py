import logging


def get_logger(name, to_sderr=False):
    tmp_dir = "/tmp/"
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    logger.propagate = False
    file_handler = logging.FileHandler(tmp_dir + name + ".log", "w")
    file_handler.setLevel(logging.DEBUG)
    logger.addHandler(file_handler)
    return logger, file_handler.stream.fileno()
