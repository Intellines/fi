import logging
from logging import Logger

import logfire

from config import config

logger: Logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

logfire.configure(
    token=config.LOGFIRE_TOKEN,
    service_name=config.ENV,
    environment=config.ENV,
    send_to_logfire=True,
    console=logfire.ConsoleOptions(min_log_level="debug"),
    distributed_tracing=False,
)

logger.addHandler(logfire.LogfireLoggingHandler(level="DEBUG"))

if __name__ == "__main__":
    logger.info("Hello world!")
