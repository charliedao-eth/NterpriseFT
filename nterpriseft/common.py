from dataclasses import dataclass
from datetime import datetime
import json
import logging
from pathlib import Path


DATE_FORMAT = '%Y-%m-%d %H:%M:%S'
DATA_PATH = Path('./data/')
CONFIG_FILE = 'config.json'
LOGGING_FILE = 'nterprise.log'


logging.basicConfig(
    level='DEBUG',
    format='%(asctime)s %(levelname)s - %(message)s',
    datefmt=DATE_FORMAT,
    filename=DATA_PATH / LOGGING_FILE
)

log = logging.getLogger('nterpriseft')


def record_time(start_time: datetime) -> None:
    end_time = datetime.now()
    duration = (end_time - start_time).seconds
    log.info(f'Took {round(duration, 3)} s')


@dataclass
class Collection:

    name: str
    symbol: str
    address: str

class Configuration:

    def __init__(self):
        self.collections: list[Collection] = self.generate()

    def generate(self) -> list[Collection]:
        path = Path(DATA_PATH / CONFIG_FILE)
        with open(path, mode='r', encoding='utf-8') as stream:
            config = json.load(stream)
        collections = [Collection(**collection) for collection in config['collections']]
        return collections
