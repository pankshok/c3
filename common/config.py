class Config(object):
    C3_LOG = "/var/log/c3"
    C3_PID = "/var/run/c3/lock"
    C3_LOCK = C3_PID

    DEBUG=False
    TESTING=False

    MAX_REQUEST_SIZE = 10 * 1024
    """Maximum possible size of incoming request"""

class ProductionConfig(Config):
    pass

class DevelopmentConfig(Config):
    DEBUG=True

class TestingConfig(Config):
    TESTING=True

config = Config()
