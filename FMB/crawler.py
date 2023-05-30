#!/usr/bin/python3

from bs4 import BeautifulSoup
from requests.adapters import HTTPAdapter, Retry
from requests.exceptions import ConnectionError
from retry import retry
from loguru import logger
import requests, os, time, json

configs = {
    'contracts_root': 'contracts/',
}

REQ_HEADER = {
    'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.61 Safari/537.36',
}
BASEURL = 'https://etherscan.io'
MONTH = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
logger.add('logs/crawler_daily.log', rotation="00:00", level="TRACE")
logger.add('logs/crawler_warning.log', rotation="00:00", level="WARNING")

class EtherscanCrawler:

    def __init__(self) -> None:
        self.session = requests.Session()
        self.session.mount('https://', HTTPAdapter(max_retries=Retry(
            total=3,
            backoff_factor=0.5, # A backoff factor to apply between attempts
            status_forcelist=[500, 502, 503, 504]
        )))

    @retry(ConnectionError, tries=3, delay=10)
    def get_etherscan_page(self, request_url: str) -> str:
        ret = self.session.get(request_url, headers=REQ_HEADER).content.decode()
        if 'Sorry, our servers are currently busy' in ret:
            logger.trace('Request too fast, retrying...')
            raise ConnectionError
        return ret

    def get_source_code(self, address: str, name: str) -> int:
        ret = self.get_etherscan_page(f'{BASEURL}/address/{address}#code')
        soup = BeautifulSoup(ret, 'html.parser')
        
        root_path = f'{configs["contracts_root"]}/{address}_{name}'
        os.makedirs(root_path, exist_ok=True)

        def parse_file_name(text: str) -> str:
            num_text, name_text = text.strip().split(':')
            _, n, _, total = num_text.split()
            if n == '1' and total == '1' and name_text.strip() == 'main':
                return f'{name}.sol'
            return f'{n}_{total}_{name_text.strip()}'

        def write_source_file(file_name: str, source_code: str) -> None:
            with open(f'{root_path}/{file_name}', 'w') as f:
                f.write(source_code)
            logger.info(f'Contract {name} at {address} source code file {file_name} is saved.')

        files = [parse_file_name(name.text) for name in soup.select('.d-flex > .text-muted') if 'File' in name.text] or \
                [parse_file_name(name.text) for name in soup.select('.d-flex > .text-secondary') if 'File' in name.text]
        sources = [source.text for source in soup.select('.js-sourcecopyarea')]
        
        if not files:
            if not sources:
                logger.error(f'No source code found for contract {name} at {address}.')
                return 1
            if len(sources) > 1:
                logger.error(f'Multiple source code files found for contract {name} at {address} with no file name.')
                return 1
            write_source_file(f'{name}.sol', sources[0])
            return 0

        for file_name, source_code in zip(files, sources):
            write_source_file(file_name, source_code)

        return 0

if __name__ == '__main__':
    ecrawler = EtherscanCrawler()
    ecrawler.get_source_code("0xdb8a9347b548084c015cea07a4ea945a997f5d1d", "FlappyMoonBird")
