#' Event Adjusted Follower Growth
#'
#' @name plot_follower_events
#' 
#' @title plot_follower_events
#' 
#'@description Plots the growth in followers relative to major twitter post
#' as defined by top N primary tweets by: (1 + likes) * (1 + retweets) 
#' 
#' 
#' @param primary_tweets Tweets directly from the account (not replies/retweets) 
#' @param retweet_x_likes Retweet x Likes column, default `retweet_x_likes`
#' @param history number of followers over time
#' @param datecol Date column, default `date`
#' @param followercol Follower column, default `followers`
#' 
#' @export
#' @examples 
#' history <- read.csv("data/bayc_history.csv", row.names = NULL)
#' primary_tweets <- jsonlite::fromJson("data/bayc_tweets")$primary_tweets
#' plot_followers(history)
#' plot_followers(history, logscale = TRUE)

plot_follower_events <- function(primary_tweets, retweet_x_likes = "retweet_x_likes",
                                 history, datecol = "date", followercol = "followers"){ 
  
  
  
  
  }