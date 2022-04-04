# Create class to pull data using the Flipside API

import urllib.request
import json


class Flipside:

    def __init__(self) -> None:

        self.project_url = {
            "MAYC": "https://api.flipsidecrypto.com/api/v2/queries/a6996134-b3e7-4f70-ba7c-5f24318d5d07/data/latest",
            "BAYC": "https://api.flipsidecrypto.com/api/v2/queries/2b5e0edf-9c64-4dc3-bd0d-15273c33363f/data/latest",
            "WoW": "https://api.flipsidecrypto.com/api/v2/queries/a45954de-bd62-438f-b000-4a8bcdc118a0/data/latest",
            "Treeverse": "https://api.flipsidecrypto.com/api/v2/queries/dad362dc-5179-488f-930c-8615c3033b72/data/latest"
        }

    def addProject(self, project_name: str, flipside_query_url: str) -> None:

        self.project_url[project_name] = flipside_query_url

    def listProjects(self, print_projects: bool = False) -> list:

        projects = [key for key in self.project_url.keys()]

        if print:
            for key in projects:
                print(key)

        return projects

    def getData(self, project) -> list:

        project_query_url = self.project_url[project]

        with urllib.request.urlopen(project_query_url) as url:
            data = json.loads(url.read().decode())

        return data
