#' Read OpenSea ETH and LooksRare NFT Sales for 
#' a single contract & token_id
#' NOTE - Covalent doesn't register OpenSea WETH offer acceptances 
#' Currently, Covalent is the only indexer that has LooksRare
#' but it requires token_id specific searches which must be brute force looped...

library(httr)
library(jsonlite)

api_key = readLines("covalent_api.txt")

get_token_sales <- function(api_key, contract_address, token_id){ 
  #' Returns a data frame of tx-id, sales price (in ETH)
  
  nft_tx_url = "https://api.covalenthq.com/v1/1/tokens/"
  
  url = paste0(nft_tx_url, 
               contract_address,
               "/nft_transactions/",
               token_id,
               "/?key=", api_key,
               "&quote-currency=ETH")
  
  response <- VERB("GET", url, accept_json())
  raw <- content(response, "text", encoding = "UTF-8")
  tbl <- fromJSON(raw)
  
  tx = tbl$data$items$nft_transactions[[1]][, c("block_signed_at","tx_hash","from_address","to_address","value")]
  
  tx$value_eth <- as.numeric(tx$value)/1e18 # originally in wei
  
  tx$from = tx$from_address
  tx$to = tx$to_address
  tx$contract_address = rep(contract_address, nrow(tx))
  tx$token_id = rep(token_id, nrow(tx))
  
  tx <- tx[, c("contract_address","token_id","block_signed_at","tx_hash","value_eth","from_address","to_address")]
  colnames(tx) <- c(
    "contract_address","token_id",
    "block_timestamp","tx_id",
    "value_eth","from","to")
  
  return(tx)
}





