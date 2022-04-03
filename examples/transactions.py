from nterpriseft.common import Configuration, DATA_PATH
from nterpriseft.ingest import CovalentIngestor
from nterpriseft.transform import CovalentTransformer
# from nterpriseft.report import (
#     CommunityReport,
#     PriceReport,
#     OwnerReport,
#     DecentralisationReport
# )
# from nterpriseft.publish import Publisher


def main():

    configuration = Configuration()
    collections = configuration.collections

    ingestor = CovalentIngestor()
    transformer = CovalentTransformer()

    for collection in collections:
        address = collection.address

        tokens_raw = ingestor.get_tokens(address)
        tokens = transformer.transform_tokens(tokens_raw)
        token_ids = tokens['token_id'].tolist()

        transactions_raw = ingestor.get_transactions(address, token_ids[:100])
        transactions = transformer.transform_transactions(transactions_raw)
        transactions.to_csv(DATA_PATH / 'transactions' / (f'{collection.symbol}.csv'), index=False)

    # community_report = CommunityReport()
    # contract_address = config.get(symbol="WOW")
    # balances_raw = covalent_api.get_balances(contract_address)
    # balances = covalent_transformer(balances_raw)
    # report = community_report.create(balances)
    # final_report = Publisher(report)
    # final_report.publish(format='pdf')


if __name__ == '__main__':

    main()
