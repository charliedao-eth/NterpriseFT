# Create Class to pull data from socialblade

import requests


class SocialBlade:

    def __init__(self, client_id: str, token: str) -> None:

        self.clientID = client_id
        self.token = token
        self.url = 'https://matrix.sbapis.com/b/twitter/statistics'

    def getHistory(self, account: str, amount: str = 'vault'):

        header = {
                 'query': account,
                 'history': amount,
                 'clientid': self.clientID,
                 'token': self.token
                 }

        response = requests.get(self.url, headers=header)
        follower_stats = response.json()


