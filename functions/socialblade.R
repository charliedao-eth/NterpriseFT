# Get Follower History from Social Blade ----
# Default 30 days, use 3 credits to get archive

library(httr)
library(jsonlite)

source("api-keys/socialblade_api.R")


get_history <- function(account, socialblade = api_socialblade, amount = "vault"){ 
  
  url = "https://matrix.sbapis.com/b/twitter/statistics"
  
follower_stats <- GET(url,
                      add_headers(
                        'query' = account,
                        'history' = amount,
                        'clientid' = socialblade$clientid,
                        'token' = socialblade$token)
)

follower_stats <- content(follower_stats)

follower_count_history <- do.call(what = rbind, 
                                  args = lapply(X = follower_stats$data$daily, rbind.data.frame)
)
}