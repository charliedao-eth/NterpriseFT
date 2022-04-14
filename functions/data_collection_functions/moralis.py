# Pull data from the moralis API

import math
import pandas as pd
import time
import requests
import warnings
import math


class Moralis:

    def __init__(self,  api: str) -> None:
        self.OwnerURL = 'http://deep-index.moralis.io/api/v2/nft/'
        self.NFTURL = 'http://deep-index.moralis.io/api/v2/'
        self.APIKey = api
        self.header = {
                       'accept': 'application/json',
                       'X-API-Key': self.APIKey
                      }
        # Schemas for data returned from successful API call.
        # Taken from https://deep-index.moralis.io/api-docs/#/token/getTokenIdOwners
        self.owner_columns = ['token_address', 'token_id', 'contract_type', 'owner_of', 'block_number',
                              'block_number_minted', 'token_uri', 'metadata', 'synced_at', 'amount', 'name', 'symbol']
        self.nft_columns = ['token_address', 'token_id', 'contract_type', 'owner_of', 'block_number',
                            'block_number_minted', 'token_uri', 'metadata', 'synced_at', 'amount', 'name', 'symbol']

    def createOwnerURL(self,
                       contract_address: str,
                       offset: int) -> str:

        url = self.OwnerURL \
              + contract_address \
              + "/owners?chain=eth&format=decimal&offset=" \
              + str(offset) \
              + "&order=token_id.ASC" \

        return url

    def createNFTURL(self,
                     address: str,
                     offset: int) -> str:

        url = self.NFTURL \
              + address \
              + "/nft?chain=eth&format=decimal&offset=" \
              + str(offset)

        return url

    def createNFTsURL(self,
                      address: str) -> str:

        url = self.NFTURL \
              + address \
              + "/nft?chain=eth&format=decimal"

        return url

    def getOwners(self,
                  contract_address: str,
                  num_tokens: int,
                  offset: int = 0,
                  slow: int = 1) -> pd.DataFrame:

        num_loops = math.ceil(num_tokens / 500)

        owners = pd.DataFrame(columns=self.owner_columns)

        for i in range(1, num_loops + 1):
            time.sleep(slow)
            url = self.createOwnerURL(contract_address, offset)
            response = requests.get(url, headers=self.header)

            # Need to put this in an appropriate try catch - How to deal with requests.exceptions.JSONDecodeError
            the_json = response.json()

            if len(the_json['message']) > 0:
                if the_json['message'] == "Rate limit exceeded.":
                    warnings.warn("50 requests/min exceeded at {} loop offset {}".format(i, offset))
                    time.sleep(60)
                    i = i-1
            else:
                data = the_json['result']
                # Will need to check if this set of code automatically takes care of missing values
                owners = owners.append(data, ignore_index=True)
                offset = offset + 500

        return owners

    def countOwners(self, owners: pd.DataFrame) -> pd.DataFrame:

        owned_per_owner = owners.groupby('owner_of', as_index=False, dropna=False)['token_id'] \
                                .count() \
                                .sort_values('token_id', ascending=False) \
                                .rename(columns={'token_id': 'number_of_tokens_owned'})

        return owned_per_owner

    def get_nft(self, address: str, offset: int = 0):

        url = self.createNFTURL(address, offset)
        response = requests.get(url, headers=self.header)

        # Need to put this in an appropriate try catch - How to deal with requests.exceptions.JSONDecodeError
        the_json = response.json()
        result = pd.DataFrame(columns=self.nft_columns)
        data = the_json['result']
        # Will need to check if this set of code automatically takes care of missing values
        result = result.append(data, ignore_index=True)

        return result

    def get_nfts(self, address) -> pd.DataFrame:

        url = self.createNFTsURL(address)
        response = requests.get(url, headers=self.header)

        # Need to put this in an appropriate try catch - How to deal with requests.exceptions.JSONDecodeError
        the_json = response.json()
        owned_nfts_tbl = pd.DataFrame(columns=self.nft_columns)
        data = the_json['result']
        # Will need to check if this set of code automatically takes care of missing values
        owned_nfts_tbl = owned_nfts_tbl.append(data, ignore_index=True)

        num_nfts = the_json['total']

        if num_nfts > 500:
            runs = math.ceil(num_nfts/500)

            for i in range(2, runs + 1):
                result = self.get_nft(address, offset=(i-1)*500)
                owned_nfts_tbl = owned_nfts_tbl.append(result)

        return owned_nfts_tbl

    def nfts_owned(self, owners: list):

        owner_nfts = {}
        unique_owners = set(owners)

        for owner in unique_owners:
            owner_nfts[owner] = self.get_nfts(owner)

        return owner_nfts