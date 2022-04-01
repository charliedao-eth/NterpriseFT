import os

from dotenv import load_dotenv
import pandas as pd
import requests


load_dotenv()


class Covalent():

    def __init__(self):
        self.api_base_url = "https://api.covalenthq.com"
        self.api_version = "v1"
        self.api_key = os.environ.get("COVALENT_API_KEY")
        self.api_rate_limit_seconds = 1/20
        self.chain_id = 1 # Ethereum Mainnet

    def _generate_url(self, endpoint: str) -> str:
        url = f"{self.api_base_url}/{self.api_version}/{self.chain_id}/{endpoint}"
        return url

    def _add_authentication(self, base_url: str) -> str:
        if "/?" in base_url:
            authentication_body = f"&key={self.api_key}"
        else:
            authentication_body = f"/?key={self.api_key}"
        url = base_url + authentication_body
        return url

    @staticmethod
    def _convert_response(response: requests.Response) -> pd.DataFrame:
        data = response.json()["data"]["items"]
        results = pd.DataFrame(data)
        return results

    def get_balances(self, wallet_address: str) -> pd.DataFrame:
        """
        get_balances(wallet_address)

        Retrieve the balance of a wallet address.

        Parameters
        ----------
        wallet_address : str
            A wallet address.

        Returns
        -------
        DataFrame
            Dataframe containing balance of wallet.

        """
        url = self._generate_url("address")
        url = url + f"/{wallet_address}/balances_v2"
        url = self._add_authentication(url)
        response = requests.get(url)
        results = self._convert_response(response)
        return results

    def get_transfers(self, wallet_address: str, contract_address: str) -> pd.DataFrame:
        url = self._generate_url("address")
        url = url + f"/{wallet_address}/transfers_v2/?contract-address={contract_address}"
        url = self._add_authentication(url)
        response = requests.get(url)
        results = self._convert_response(response)
        return results

    def get_owners(self, wallet_address: str) -> pd.DataFrame:
        url = self._generate_url("tokens")
        url = url + f"/{wallet_address}/token_holders"
        url = self._add_authentication(url)
        response = requests.get(url)
        results = self._convert_response(response)
        return results

    def get_tokens(self, contract_address: str) -> pd.DataFrame:
        url = self._generate_url("tokens")
        url = url + f"/{contract_address}/nft_token_ids"
        url = self._add_authentication(url)
        response = requests.get(url)
        results = self._convert_response(response)
        return results

    def get_contract_transactions(self, contract_address: str, token_id: str) -> pd.DataFrame:
        url = self._generate_url("tokens")
        url = url + f"/{contract_address}/nft_transactions/{token_id}"
        url = self._add_authentication(url)
        response = requests.get(url)
        results = self._convert_response(response)
        return results

    def get_wallet_transactions(self, wallet_address: str) -> pd.DataFrame:
        url = self._generate_url("address")
        url = url + f"/{wallet_address}/transactions_v2"
        url = self._add_authentication(url)
        response = requests.get(url)
        results = self._convert_response(response)
        return results


class Moralis():

    def __init__(self):
        self.api_base_url = "https://deep-index.moralis.io/api"
        self.api_version = "v2"
        self.api_key = os.environ.get("MORALIS_API_KEY")
        self.api_rate_limit_seconds = 1/60
        self.chain = "eth" # Ethereum Mainnet
