from datetime import datetime

import pandas as pd

from nterpriseft.common import log, record_time


pd.options.mode.chained_assignment = None


class CovalentTransformer:

    def transform_balances(self, balances_raw: pd.DataFrame) -> pd.DataFrame:
        log.info('Transforming balances...')
        start_time = datetime.now()
        balances = balances_raw[[
            'contract_name',
            'contract_ticker_symbol',
            'contract_address',
            'balance'
        ]]
        record_time(start_time)
        return balances

    def transform_transfers(self, transfers_raw: pd.DataFrame) -> pd.DataFrame:
        log.info('Transforming transfers...')
        start_time = datetime.now()
        transfers = transfers_raw[[
            'block_signed_at',
            'successful',
            'tx_hash',
            'from_address',
            'to_address',
            'value',
            'gas_offered',
            'gas_spent',
            'gas_price'
        ]]
        record_time(start_time)
        return transfers

    def transform_owners(self, owners_raw: pd.DataFrame) -> pd.DataFrame:
        log.info('Transforming owners...')
        start_time = datetime.now()
        owners = owners_raw[[
            'contract_name',
            'contract_ticker_symbol',
            'contract_address',
            'address',
            'balance'
        ]]
        record_time(start_time)
        return owners

    def transform_tokens(self, tokens_raw: pd.DataFrame) -> pd.DataFrame:
        log.info('Transforming tokens...')
        start_time = datetime.now()
        tokens = tokens_raw[[
            'contract_name',
            'contract_ticker_symbol',
            'contract_address',
            'token_id'
        ]]
        record_time(start_time)
        return tokens

    def transform_transactions(self, transactions_raw: pd.DataFrame) -> pd.DataFrame:
        log.info('Transforming transactions...')
        start_time = datetime.now()
        columns_relevant = [
            'block_signed_at',
            'successful',
            'tx_hash',
            'from_address',
            'to_address',
            'value',
            'gas_offered',
            'gas_spent',
            'gas_price'
        ]
        transactions = []
        for _, row in transactions_raw.iterrows():
            transaction_detail = pd.DataFrame(row['nft_transactions'])
            if len(transaction_detail) > 0:
                transaction = transaction_detail[columns_relevant]
                transaction.loc[:, 'contract_name'] = row['contract_name']
                transaction.loc[:, 'contract_ticker_symbol'] = row['contract_ticker_symbol']
                transaction.loc[:, 'contract_address'] = row['contract_address']
                transaction.loc[:, 'token_id'] = row['token_id']
                transactions.append(transaction)
        if len(transactions) > 0:
            transactions = pd.concat(transactions).reset_index(drop=True)
        else:
            transactions = pd.DataFrame()
        record_time(start_time)
        return transactions
