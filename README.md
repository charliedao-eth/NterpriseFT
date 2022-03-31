# NterpriseFT

 Full cycle data analysis of NFT sales, communities, social media and their intereconnectedness.

## Current Status 

Due to API Rate Limits that cannot be overcome (even with money...) only the following
data timestamped to February 6th, 2022 is available for analysis: 

- Socialblade: Twitter Followers over time (daily)
- Moralis: Current Owners of NFTs
- FlipSide Crypto: OpenSea ETH and WETH sales (~~no LooksRARE API yet)~~ LOOKSRARE has been integrated! Updating the data (and time-stamp).
- Twitter: Latest 3,200 tweets
- Etherscan: Daily average gas cost


| Item                 | Meaning                                                                                                                                                                    |
|----------------------|-----|
| HISTORY TABLE        | Twitter history over time from SocialBlade                                                                                                                                 |
| date                 | Day of data                                                                                                                                                                |
| followers            | # of TOTAL followers timestamped to that day; should grow over time.                                                                                                       |
| following            | # of TOTAL accounts followed by the group timestamped to that day; may   stay low, or decrease over time; not super interesting.                                           |
| tweets               | # of TOTAL tweets as of that day; should grow over time.                                                                                                                   |
| favorites            | # of TOTAL "likes" across all tweets up to that day; should   grow over time.                                                                                              |
|                      |                                                                                                                                                                            |
| SALES TABLE          | NFT Sales over time from FlipSide Crypto                                                                                                                                   |
| BLOCK_TIMESTAMP      | timestamp of the block that includes the sale tx.                                                                                                                          |
| EVENT_FROM           | Seller ETH address                                                                                                                                                         |
| EVENT_TO             | Buyer ETH address                                                                                                                                                          |
| PRICE                | # of tokens used to purchase                                                                                                                                               |
| PROJECT_NAME         | NFT Collection name                                                                                                                                                        |
| TOKEN_ID             | The ID number of the NFT being sold in the NFT Collection contract   address                                                                                               |
| TX_CURRENCY          | The currency of the PRICE (ETH or WETH, both are equivalent, all other   currencies ignored in this data so far)                                                           |
| TX_ID                | The individual ETH hash that corresponds to this sale.                                                                                                                     |
|                      |                                                                                                                                                                            |
| ETH DAILY GAS        | The average gas cost for an ETH transaction on the day.                                                                                                                    |
| DATE.UTC             | The date in UTC                                                                                                                                                            |
| UNIXTIMESTAMP        | The timestamp                                                                                                                                                              |
| Value Wei            | The average gas cost for a tx across the entire day (1 wei = 1 * 10^(-18)   ETH)                                                                                           |
|                      |                                                                                                                                                                            |
| OWNER TABLE          | Who owns which NFT Token ID - from Moralis                                                                                                                                 |
| token_address        | The smart contract address for the NFT Collection                                                                                                                          |
| token_id             | The ID number of the NFT being sold in the NFT Collection contract   address                                                                                               |
| block_number_minted  | The block when the ID was first minted                                                                                                                                     |
| owner_of             | The owner of the token_id at the time of data collection                                                                                                                   |
| block_number         | block_number when token was last purchased                                                                                                                                 |
| amount               | amount of that token_id owned (always 1 for ERC-721)                                                                                                                       |
| contract_type        | Whether the NFT is an ERC-721 or an ERC-1155 (will be ERC-721)                                                                                                             |
| name                 | Name of NFT Collection                                                                                                                                                     |
| symbol               | NFT Collection Symbol                                                                                                                                                      |
| token_uri            | Location of JPEG corresponding to token ID                                                                                                                                 |
| metadata             | image location, traits, and other metadata related to the token id                                                                                                         |
| synced_at            | last timestamped data                                                                                                                                                      |
| is_valid             | Ignore                                                                                                                                                                     |
| syncing              | Ignore                                                                                                                                                                     |
| frozen               | Ignore                                                                                                                                                                     |
|                      |                                                                                                                                                                            |
| TWEETS TABLE         | Two tables, the raw "all_tweets" table which includes replies   and retweets; and the "primary_tweets" table, which excludes   replies and retweets and drops most column. |
| created_at           | When the tweet was tweeted                                                                                                                                                 |
| text                 | The text of the tweet (may have weird Unicode issues with emojis)                                                                                                          |
| favorite_count       | number of times the tweet was "liked"                                                                                                                                      |
| retweet_count        | number of times the tweet was retweeted                                                                                                                                    |
| retweet_x_like_ratio | retweet_count divided by favorite_count                                                                                                                                    |
| retweet_x_like       | (1 + retweet_count) times (1 + favorite_count), acts as an   "engagement score"                                                                                            |
