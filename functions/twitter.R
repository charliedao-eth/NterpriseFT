# Get Follower list, tweet history, and 2nd degree followers

library(dplyr)
library(httr)
library(rvest)
library(rtweet)

# Create Twitter API Token
source("api-keys/twitter_api.R")

# Current Follower Count ----

get_follower_count <- function(account){ 
  url <- paste0("http://socialblade.com/twitter/user/",
                account,
                "/realtime")
  # Website requires a user-agent header - not sure if this is something
  # they want real data for or just a default in their architecture 
  x <- GET(url, 
           add_headers('user-agent' = 'Just some guy ([[abc123@gmail.com]])'))
  
  raw_count <- { 
    read_html(x) %>% html_nodes("p") %>% 
      grep(pattern = "rawCount", value = TRUE) %>% 
      gsub(pattern =  "[^0-9]",replacement = "") %>% 
      as.numeric()
  }
  
  # If < 5 followers, social blade doesn't include them,
  # account is treated as effectively 0 followers. 
  
  if(length(raw_count) == 0){ 
    raw_count <- 0 
  }
  
  return(raw_count)
}

# Get list of followers & number of their followers for REACH ----

get_followers <- function(account, token = twitter_token){
  
  followers <- rtweet::get_followers(user = account,
                                     retryonratelimit = TRUE,
                                     token = token)
  
  followers$screen_name <- rtweet::lookup_users(followers$user_id)$screen_name
  
  follower_count = data.frame(
    screen_name = followers$screen_name, 
    follower_count = rep(NA, length(followers$screen_name))
  )
  
  # Try first pass 
  for(i in 1:nrow(follower_count)){ 
    print(i) 
    follower_count$follower_count[i] <- tryCatch(
      get_follower_count(follower_count$screen_name[i]), error = "FAILED"
    )
  }
  
  # just in case website starts hatin' try again with all 0s. 
  
  follower_count_zero <- follower_count %>% filter(follower_count == 0)
  
  for(i in 1:nrow(follower_count_zero)){ 
    follower_count_zero$follower_count[i] <- tryCatch(
      get_follower_count(follower_count_zero$screen_name[i]), error = "FAILED"
    )
  }
  
  follower_count <- follower_count[follower_count$follower_count != 0, ]
  follower_count <- rbind.data.frame(follower_count, follower_count_zero)
  
  followers <- merge(followers, follower_count, by = "screen_name")
  
  return(followers)
  
  }


# Get Up to 3200 past Tweets ----

get_tweets <- function(account, n = 3200, token = twitter_token){ 
  all_tweets <- rtweet::get_timeline(user = account,n = n, token = token)
  primary_tweets <- all_tweets %>% filter(is_quote == FALSE,
                                          is_retweet == FALSE, 
                                          is.na(reply_to_screen_name))
  
  tweets <- primary_tweets[, c("created_at",
                               "text",
                               "favorite_count",
                               "retweet_count")]
  
  
  tweets$retweet_like_ratio <- ifelse(tweets$favorite_count == 0, 
                                      yes = 0,
                                      no =  tweets$retweet_count/tweets$favorite_count)
  tweets$retweet_x_like <- (tweets$favorite_count + 1)*(tweets$retweet_count+1)
  
  return(
    list(all_tweets = all_tweets, primary_tweets = tweets)
  )
  
  }

