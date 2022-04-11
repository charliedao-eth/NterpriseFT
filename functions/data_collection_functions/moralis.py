# Pull data from the moralis API

import math
import pandas

class Moralis:

    def __init__(self) -> None:
        self.url = 'http://deep-index.moralis.io/api/v2/nft/'
        self.APIkey = ''

    def setAPI(self, api: str) -> None:

        self.APIKey = api

    def createURL(self,
                  contract_address: str,
                  offset: int) -> str:

        url = self.url \
              + contract_address \
              + "/owners?chain=eth&format=decimal&offset=" \
              + str(offset) \
              + "&order=token_id.ASC" \

        return url

    def fillnull(self):

        x = 5

    def getOwners(self,
                contract_address: str,
                num_tokens: int,
                offset: int = 0,
                slow: int = 1):

        num_loops = math.ceil(num_tokens / 500)



