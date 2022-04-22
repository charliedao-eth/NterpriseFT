# Create class to pull data using the Covalent API
import pandas as pd
import requests
import math


class Covalent:

    def __init__(self, api: str) -> None:
        self.nft_tx_url = 'https://api.covalenthq.com/v1/1/tokens/'
        self.APIKey = api
        self.header = {
                       'accept': 'application/json'
                      }
        self.columns = ['block_signed_at', 'tx_hash', 'from_address', 'to_address', 'value']
        self.rename = {
                        'block_signed_at': 'block_timestamp',
                        'tx_hash': 'tx_id',
                        'from_address': 'from',
                        'to_address': 'to'
                      }

    def createURL(self, contract_address: str, token_id: str) -> str:

        url = self.nft_tx_url \
              + contract_address \
              + "/nft_transactions/" \
              + token_id \
              + "/?key=" \
              + self.APIKey \
              + "&quote-currency=ETH"

        return url

    def getTokenSales(self, contract_address: str, token_id: str) -> pd.DataFrame:

        url = self.createURL(contract_address, token_id)

        response = requests.get(url, headers=self.header)
        the_json = response.json()

        data = the_json['items']['nft_transactions']

        data = pd.DataFrame.from_dict(data)

        data = data[self.columns]

        data = data.assign( contract_address=contract_address, token_id=token_id)

        data['value_eth'] = data['value']/math.pow(10, 18)
        data = data.drop(columns=['value'])

        data = data.rename(columns=self.rename)

        return data






