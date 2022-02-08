#' 1a) This script uses the functions/flipside.R script 
#' to pull OS ETH & WETH sales data from Flipside Crypto 
#' for BAYC, MAYC, World of Women, and Treeverse NFTs with a daily refresh. 
#'
#' 1b) If time permitted, it then uses a long loop to check ALL token_ids from ALL collections
#' as defined in the functions/covalent.R script
#' This brings OS ETH & LooksRare marketplace data
#' At time of writing, this is the only way to get all three of: 
#'  OpenSea ETH sales
#'  OpenSea WETH sales
#'  LooksRare sales
#' For an NFT collection.
#' 
#' 1c) If time permitted it would combine (a) and (b) to create a sales table with mints and OpenSea duplicates
#' removed. 
#' 
#' 2) It uses the Moralis API to get current owner data for each collection 
#' 
#' 3) It uses the Moralis API to get all NFTs owned by each unique owner across 
#' all collections and for OpenSea ERC-1155 Shared Storefront NFTs it parses the 
#' metadata to identify the collection name. 
#'
#' 4) It uses the socialblade API to get twitter follower histories
#' for each collection (BAYC/MAYC share the same twitter, WoW, and TheTreeverse)
#' 
#' 5) It uses the Twitter API to get all tweets from each collection's official twitter account
#' and related metadata. 

# Flipside Data ----

 # OpenSea ETH & WETH Sales
source("functions/flipside.R")

# Covalent Data NOT USED ----

# BAYC Contract: 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D
# MAYC Contract: 0x60E4d786628Fea6478F785A6d7e704777c86a7c6
# World of Women Contract: 0xe785E82358879F061BC3dcAC6f0444462D4b5330
# Treeverse Contract: 0x1B829B926a14634d36625e60165c0770C09D02b2

source("functions/covalent.R")
covalent_api = readLines("api-keys/covalent_api.txt")
bayc_contract = "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D"
mayc_contract = "0x60E4d786628Fea6478F785A6d7e704777c86a7c6"
wow_contract = "0xe785E82358879F061BC3dcAC6f0444462D4b5330"
treeverse_contract = "0x1B829B926a14634d36625e60165c0770C09D02b2"

## BAYC & MAYC ---- 


if(exists("bayc_sales")){
  write.csv(x = bayc_sales, file = "data/bayc_sales.csv", row.names = FALSE)
}


if(exists("mayc_sales")){
  write.csv(x = mayc_sales, file = "data/mayc_sales.csv", row.names = FALSE)
}

### Check all IDs
# TOO SLOW TO USE :/ 
# num_tokens = 20000
# bayc_transfers <- { 
#   do.call(bind_rows, 
#           args = lapply(1:num_tokens, FUN = function(x){ 
#             get_token_sales(bayc_contract, x, covalent_api)
#             }))
#   }


### Twitter Followers ---- 
# Can't get due to RATE LIMIT
# source("functions/twitter.R")
# 
bayc_account = "BoredApeYC"
# 
# bayc_followers <- get_follower_count(account = bayc_account)

### Follower Growth ----
 # cost tokens don't do this often 

source("functions/socialblade.R")

are_you_sure = FALSE
if(are_you_sure == TRUE){ 
bayc_history <- get_history(bayc_account,
                            socialblade = api_socialblade,
                            amount = "vault")
} else { 
  "didn't run socialblade to save credit costs"
}

if(exists("bayc_history")){
  write.csv(bayc_history, "data/bayc_history.csv", row.names = FALSE)
}

### Tweets ---- 
source("functions/twitter.R")
bayc_tweets <- get_tweets(account = bayc_account, n = 3200, token = twitter_token)
write_json(bayc_tweets, "data/bayc_tweets.json")

### Current Owners ----
source("functions/moralis.R")
bayc_owners <- get_owners(contract_address = bayc_contract,
                          num_tokens = 10000, 
                          key = moralis_key)
write_json(x = bayc_owners, "data/bayc_owners.json")

# Mayc Owners 
mayc_owners <- get_owners(contract_address = mayc_contract,
                          num_tokens = 20000, 
                          key = moralis_key)
write_json(x = mayc_owners, "data/mayc_owners.json")


## WOW ----

if(exists("wow_sales")){
  write.csv(x = wow_sales, file = "data/wow_sales.csv", row.names = FALSE)
}

wow_account <- "worldofwomennft"

are_you_sure = FALSE
if(are_you_sure == TRUE){ 
  wow_history <- get_history(wow_account,
                              socialblade = api_socialblade,
                              amount = "vault")
} else { 
  "didn't run socialblade to save credit costs"
}

if(exists("wow_history")){
  write.csv(wow_history, "data/wow_history.csv", row.names = FALSE)
}

### Tweets ---- 
wow_tweets <- get_tweets(account = wow_account, n = 3200, token = twitter_token)
write_json(wow_tweets, "data/wow_tweets.json")

### Current Owners ----
wow_owners <- get_owners(contract_address = wow_contract,
                          num_tokens = 10000, 
                          key = moralis_key)
write_json(x = wow_owners, "data/wow_owners.json")
## Treeverse ---- 

if(exists("treeverse_sales")){
  write.csv(x = treeverse_sales, file = "data/treeverse_sales.csv", row.names = FALSE)
}

treeverse_account <- "TheTreeverse"

are_you_sure = FALSE
if(are_you_sure == TRUE){ 
  treeverse_history <- get_history(treeverse_account,
                             socialblade = api_socialblade,
                             amount = "vault")
} else { 
  "didn't run socialblade to save credit costs"
}

if(exists("treeverse_history")){
  write.csv(treeverse_history, "data/treeverse_history.csv", row.names = FALSE)
}

### Tweets ---- 
treeverse_tweets <- get_tweets(account = treeverse_account, n = 3200, token = twitter_token)
write_json(treeverse_tweets, "data/treeverse_tweets.json")

### Current Owners ----
treeverse_owners <- get_owners(contract_address = treeverse_contract,
                         num_tokens = 10000, 
                         key = moralis_key)
write_json(x = treeverse_owners, "data/treevese_owners.json")
