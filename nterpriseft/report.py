# TODO in construction

from datetime import datetime

import pandas as pd

from nterpriseft.common import log, record_time


TIMESTAMP_FORMAT = '%Y-%m-%dT%H:%M:%SZ'


class Reporter:

    def __init__(self, transactions: pd.DataFrame):
        self.transactions = transactions
        self.transactions['date'] = str(datetime.strptime(transactions['block_signed_at'], TIMESTAMP_FORMAT).date())
        self.non_zero_transactions = self._filter_transactions(self.transactions)
        self.aggregated_tokens = self._aggregate_tokens(self.non_zero_transactions)
        self.aggregated_transactions = self._aggregate_transactions(self.non_zero_transactions)

    def _filter_transactions(self, transactions: pd.DataFrame) -> pd.DataFrame:
        start_time = datetime.now()
        initial_row_count = transactions.shape[0]
        non_zero_transactions = transactions[transactions['value'] > 0]
        filtered_row_count = non_zero_transactions.shape[0]
        log.info(f'Filtered transactions from {initial_row_count} rows to {filtered_row_count} rows')
        record_time(start_time)
        return non_zero_transactions

    def _aggregate_tokens(self, transactions: pd.DataFrame) -> pd.DataFrame:
        start_time = datetime.now()
        aggregated_tokens = transactions.groupby('token_id')
        record_time(start_time)
        return aggregated_tokens

    def _aggregate_transactions(self, transactions: pd.DataFrame) -> pd.DataFrame:
        start_time = datetime.now()
        aggregated_transactions = transactions.groupby('date')
        record_time(start_time)
        return aggregated_transactions

    def report_token_price_mean(self) -> pd.DataFrame:
        token_price_means = self.aggregated_tokens['value'].mean()
        return token_price_means

    def report_token_price_risk(self) -> pd.DataFrame:
        token_price_risks = self.aggregated_tokens['value'].std()
        return token_price_risks

    def report_token_price_distribution(self, data: pd.DataFrame) -> pd.DataFrame:
        pass

    def report_token_transfer_count(self, data: pd.DataFrame) -> pd.DataFrame:
        pass

    def report_new_owners(self, data: pd.DataFrame) -> pd.DataFrame:
        pass

    def report_unique_owners(self, data: pd.DataFrame) -> pd.DataFrame:
        pass

    def report_buy_sell_event_mean_duration(self, data: pd.DataFrame) -> pd.DataFrame:
        pass

    def report_top_owners_by_token_count(self, data: pd.DataFrame) -> pd.DataFrame:
        pass

    def report_top_owners_by_token_value(self, data: pd.DataFrame) -> pd.DataFrame:
        pass

    def report_top_tokens_by_transfer_count(self, data: pd.DataFrame) -> pd.DataFrame:
        pass

    def report_top_tokens_by_mean_sell_value(self, data: pd.DataFrame) -> pd.DataFrame:
        pass
