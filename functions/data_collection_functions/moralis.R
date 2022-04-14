# Get owners of NFT and NFTs owned by the current owners from Moralis

library(dplyr)
library(httr)

moralis_key = readLines("api-keys/moralis_api.txt")

# Utility function for infilling broken JSON content
fill_null <- function(result_){ 
  nullvector <- is.null(result_) 
  result_[ unlist(nullvector)] <- NA
  return(result_)
}

# Get current owners ----
get_owners <- function(contract_address, num_tokens, key = moralis_key, offset = 0, slow = 1){ 
  
  num_loops <- ceiling(num_tokens / 500)
  offset <- offset
  
  # initiate dataframe 
  owners <- data.frame()

  for(i in 1:num_loops){
            Sys.sleep(slow) # Slow down for API rate limit
            request <- httr::GET(
              url = paste0("http://deep-index.moralis.io/api/v2/nft/",
                           contract_address,
                           "/owners?chain=eth&format=decimal&offset=",
                           offset,
                           "&order=token_id.ASC"),
              httr::add_headers(
                `accept` = "application/json",
                `X-API-Key` = key
              )
            )

            the_json <- httr::content(request)

            if(length(the_json$message) > 0){
              if(the_json$message == "Rate limit exceeded."){
              warning(paste0("50 requests/min exceeded at ", i," loop ","offset ", offset))
                Sys.sleep(60) # if problem take a nap
                # then re-do loop
                i = i-1
              }
            } else {

              the_json$result <- lapply(the_json$result, FUN = function(x){
                lapply(x, fill_null)
              })

              # bind results to our holder data frame
              result <- bind_rows(lapply(the_json$result, list2DF))
              owners <- bind_rows(owners, result)
              offset <- offset + 500
            }

              }
  return(owners)
}

# Amount owned per owner ----

count_owners <- function(owners){ 
  owners %>% group_by(owner_of) %>% 
    summarise(count = n()) %>% dplyr::arrange(desc(count))
}

# Get page of NFT owned by a single address ----

get_nft <- function(address, api_key, offset = 0){ 
  request <- httr::GET( 
    url = paste0("http://deep-index.moralis.io/api/v2/",
                 address,
                 "/nft?chain=eth&format=decimal&offset=", offset),
    httr::add_headers(
      `accept` = "application/json", 
      `X-API-Key` = api_key
    )
  )
  
  the_json <- httr::content(request)
  
  the_json$result <- lapply(the_json$result, FUN = function(x){
    lapply(x, fill_null)
  })
  result <- bind_rows(lapply(the_json$result, list2DF))  
  return(result)
}

# Get all NFTs from an address ----
get_nfts <- function(address, api_key){
  
  request <- httr::GET( 
    url = paste0("http://deep-index.moralis.io/api/v2/",
                 address,
                 "/nft?chain=eth&format=decimal"),
    httr::add_headers(
      `accept` = "application/json", 
      `X-API-Key` = api_key
    )
  )
  
  the_json <- httr::content(request)
  
  the_json$result <- lapply(the_json$result, FUN = function(x){
    lapply(x, fill_null)
  })
  result <- bind_rows(lapply(the_json$result, list2DF))  
  
  num_nfts <- the_json$total 
  
  owned_nfts_tbl <- result  
  
  if(num_nfts > 500){
    runs = ceiling(num_nfts/500)
    
    for(i in 2:runs){
      result <- get_nft(address, api_key, offset = (i-1)*500)
      owned_nfts_tbl <- rbind(owned_nfts_tbl, result)
    }
  }
  
  return(owned_nfts_tbl)
}

# Get all NFTs owned by a set of owners
nfts_owned <- function(owners, key = moralis_key){
  
  owner_nfts <- list()
  unique_owners <- unique(owners$owner_of)
  length(owner_nfts) <- length(unique_owners)
  names(owner_nfts) <- unique_owners
  
  lapply(names(owner_nfts), function(x){
    owner_nfts[[x]] <- get_nfts(x, api_key = key)
  } )
  
  return(owner_nfts)
  
}
