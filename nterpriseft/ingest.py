from datetime import datetime
import os
import time

import pandas as pd
import requests
from tqdm import tqdm

from nterpriseft.common import log, record_time


PAGE_SIZE = 1000
MAXIMUM_ITERATIONS = 1000


class CovalentIngestor:

    def __init__(self):
        self.api_base_url = "https://api.covalenthq.com"
        self.api_version = "v1"
        self.api_key = os.environ.get("COVALENT_API_KEY")
        self.api_rate_limit_seconds = 1/20
        self.chain_id = 1 # Ethereum Mainnet

    def _generate_url(self, endpoint: str) -> str:
        log.debug(f'Generating URL using endpoint "{endpoint}"')
        url = f"{self.api_base_url}/{self.api_version}/{self.chain_id}/{endpoint}"
        return url

    def _add_authentication(self, base_url: str) -> str:
        log.debug(f'Adding authentication to base URL {base_url}')
        if "/?" in base_url:
            authentication_body = f"&key={self.api_key}"
        else:
            authentication_body = f"/?key={self.api_key}"
        url = base_url + authentication_body
        return url

    def _add_pagination(self, base_url: str, index: int) -> str:
        log.debug(f'Adding pagination with index {index} to base URL {base_url}')
        if "/?" in base_url:
            pagination_body = f"&page-size={PAGE_SIZE}&page-number={index}"
        else:
            pagination_body = f"/?page-size={PAGE_SIZE}&page-number={index}"
        url = base_url + pagination_body
        return url

    def _get_paginated_response(self, url: str) -> pd.DataFrame:
        log.debug(f'Getting paginated response with URL {url}')
        results = []
        for index in range(MAXIMUM_ITERATIONS):
            url_paginated = self._add_pagination(url, index)
            try:
                response = requests.get(url_paginated)
            except Exception as exception:
                log.error(exception)
                break
            result = self._convert_response(response)
            if len(result) == 0:
                break
            results.append(result)
            if len(result) < PAGE_SIZE:
                break
            time.sleep(self.api_rate_limit_seconds)
        if len(results) > 0:
            results = pd.concat(results)
        else:
            results = pd.DataFrame()
        return results

    @staticmethod
    def _convert_response(response: requests.Response) -> pd.DataFrame:
        log.debug('Converting response object to dataframe')
        if response.json()["data"] is None:
            log.error(f'No data in response: {response.json()}')
            time.sleep(60)
            results = pd.DataFrame()
        else:
            data = response.json()["data"]["items"]
            results = pd.DataFrame(data)
        return results

    def get_balances(self, wallet_address: str) -> pd.DataFrame:
        """
        get_balances(wallet_address)

        Retrieve balances of a wallet address.

        Parameters
        ----------
        wallet_address : str
            A wallet address.

        Returns
        -------
        DataFrame
            Dataframe containing balances of wallet.

        """
        log.info('Getting balances...')
        start_time = datetime.now()
        url = self._generate_url("address")
        url = url + f"/{wallet_address}/balances_v2"
        url = self._add_authentication(url)
        results = self._get_paginated_response(url)
        record_time(start_time)
        return results

    def get_transfers(self, wallet_address: str, contract_address: str = None) -> pd.DataFrame:
        """
        get_transfers(wallet_address, contract_address)

        Retrieve transfers from a wallet address and contract address.

        Parameters
        ----------
        wallet_address : str
            A wallet address.
        contract_address : str
            A contract address.

        Returns
        -------
        DataFrame
            Dataframe containing transfers.

        """
        log.info('Getting transfers...')
        start_time = datetime.now()
        print(self)
        url = self._generate_url("address")
        if contract_address is None:
            url = url + f"/{wallet_address}/transactions_v2"
        else:
            url = url + f"/{wallet_address}/transfers_v2/?contract-address={contract_address}"
        url = self._add_authentication(url)
        results = self._get_paginated_response(url)
        record_time(start_time)
        return results

    def get_owners(self, contract_address: str) -> pd.DataFrame:
        """
        get_owners(contract_address)

        Retrieve token owners from a contract address.

        Parameters
        ----------
        contract_address : str
            A contract address.

        Returns
        -------
        DataFrame
            Dataframe containing token owners.

        """
        log.info('Getting owners...')
        start_time = datetime.now()
        url = self._generate_url("tokens")
        url = url + f"/{contract_address}/token_holders"
        url = self._add_authentication(url)
        results = self._get_paginated_response(url)
        record_time(start_time)
        return results

    def get_tokens(self, contract_address: str) -> pd.DataFrame:
        """
        get_tokens(contract_address)

        Retrieve tokens from a contract address.

        Parameters
        ----------
        contract_address : str
            A contract address.

        Returns
        -------
        DataFrame
            Dataframe containing tokens.

        """
        log.info('Getting tokens...')
        start_time = datetime.now()
        url = self._generate_url("tokens")
        url = url + f"/{contract_address}/nft_token_ids"
        url = self._add_authentication(url)
        results = self._get_paginated_response(url)
        record_time(start_time)
        return results

    def get_transactions(self, contract_address: str, token_ids: list[int]) -> pd.DataFrame:
        """
        get_token_transactions(contract_address, token_id)

        Retrieve transactions of a token.

        Parameters
        ----------
        contract_address : str
            A contract address.
        token_id : str
            A token ID.

        Returns
        -------
        DataFrame
            Dataframe containing transactions.

        """
        log.info('Getting transactions...')
        start_time = datetime.now()
        base_url = self._generate_url("tokens")
        results = []
        for token_id in tqdm(token_ids):
            url = base_url + f"/{contract_address}/nft_transactions/{token_id}"
            url = self._add_authentication(url)
            result = self._get_paginated_response(url)
            result['token_id'] = token_id
            results.append(result)
        if len(results) > 0:
            results = pd.concat(results)
        else:
            results = pd.DataFrame()
        record_time(start_time)
        return results
