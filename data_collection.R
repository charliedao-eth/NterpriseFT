#' 1a) This script uses the functions/flipside.R script 
#' to pull OS ETH & WETH sales data from Flipside Crypto 
#' for BAYC, MAYC, World of Women, and Treeverse NFTs with a daily refresh. 
#'
#' 1b) It then uses a long loop to check ALL token_ids from ALL collections
#' as defined in the functions/covalent.R script
#' This brings OS ETH & LooksRare marketplace data
#' At time of writing, this is the only way to get all three of: 
#'  OpenSea ETH sales
#'  OpenSea WETH sales
#'  LooksRare sales 
#' For an NFT collection. 
#' 
#' 1c) It combines (a) and (b) to create a sales table with mints and OpenSea duplicates
#' removed. 
#' 
#' 2) It uses the socialblade API to get twitter follower histories
#' for each collection (BAYC/MAYC share the same twitter, WoW, and TheTreeverse)
#' 
#' 3) It uses the Moralis API to get current owner data for each collection 
#' 
#' 4) It uses the Moralis API to get all NFTs owned by each unique owner across 
#' all collections and for OpenSea ERC-1155 Shared Storefront NFTs it parses the 
#' metadata to identify the collection name. 
#'
#' 5) It uses the Twitter API to get all tweets from each collection's official twitter account
#' and related metadata. 


