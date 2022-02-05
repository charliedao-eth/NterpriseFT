#' Get OpenSea ETH and WETH sales from Flipside Crypto 
#' Already aggregated to contract level so do not need
#' to do brute force loop.
#' FlipSide API requires structuring the query within their tool
#' Then pulling a regularly scheduled refresh from a set API URL 
#' SQL Query is provided here for reproducibility
#' 

# /* Get Sales for the following NFTs 
# BAYC Contract: 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D
# MAYC Contract: 0x60E4d786628Fea6478F785A6d7e704777c86a7c6
# World of Women Contract: 0xe785E82358879F061BC3dcAC6f0444462D4b5330
# Treeverse Contract: 0x1B829B926a14634d36625e60165c0770C09D02b2
# */ 
#   
#   /*In the future only look up NEW data from AFTER a specific timestamp*/
#   SELECT project_name, token_id, block_timestamp, tx_id, event_from, event_to, price, tx_currency 
# FROM ethereum.nft_events 
# WHERE contract_address = LOWER('0xe785E82358879F061BC3dcAC6f0444462D4b5330') 
# AND event_type = 'sale'
# ORDER BY block_timestamp DESC;

library(jsonlite)

wow_url = "https://api.flipsidecrypto.com/api/v2/queries/a45954de-bd62-438f-b000-4a8bcdc118a0/data/latest"
wow_sales <- fromJSON(wow_url)

bayc_url = "https://api.flipsidecrypto.com/api/v2/queries/2b5e0edf-9c64-4dc3-bd0d-15273c33363f/data/latest"
bayc_sales <- fromJSON(bayc_url)

mayc_url = "https://api.flipsidecrypto.com/api/v2/queries/a6996134-b3e7-4f70-ba7c-5f24318d5d07/data/latest"
mayc_sales <- fromJSON(mayc_url)

treeverse_url = "https://api.flipsidecrypto.com/api/v2/queries/dad362dc-5179-488f-930c-8615c3033b72/data/latest"
treeverse_sales <- fromJSON(treeverse_url)

