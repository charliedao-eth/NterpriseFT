# Create class to pull data using the Covalent API

class Covalent:

    def __init__(self) -> None:
        self.nft_tx_url = 'https://api.covalenthq.com/v1/1/tokens/'

    def createURL(self, contract_address: str, token_id: str, api_key: str) -> str:

        url = self.nft_tx_url \
              + contract_address \
              + "/nft_transactions/" \
              + token_id \
              + "/?key=" \
              + api_key \
              + "&quote-currency=ETH"

        return url
