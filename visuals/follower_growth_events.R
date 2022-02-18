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
#' @param retweet_x_like Retweet x Likes column, default `retweet_x_like`
#' @param createdcol Date column from primary tweets, default `created_at`
#' @param n number of top tweets to consider as events, default `10`
#' @param history number of followers over time
#' @param datecol Date column, default `date`
#' @param followercol Follower column, default `followers`
#' 
#' @export
#' @examples 
#' history <- read.csv("data/bayc_history.csv", row.names = NULL)
#' primary_tweets <- jsonlite::fromJSON("data/bayc_tweets.json")$primary_tweets
#' plot_follower_events(primary_tweets, history = history)

plot_follower_events <- function(primary_tweets, 
                                 retweet_x_like = "retweet_x_like",
                                 createdcol = "created_at",
                                 n = 10, 
                                 history, 
                                 datecol = "date", 
                                 followercol = "followers"){
  
  if( !(retweet_x_like %in% colnames(primary_tweets)) ) { 
    stop("Expected retweet_x_likes column not found in primary_tweets.")
  }
  
  if( !(datecol %in% colnames(history)) | 
      !(followercol %in% colnames(history)) ) { 
    stop("Expected column names not found in data.")
  }
  
  if( class(history[[datecol]]) != "Date" ){
    warning("Converting date column to class date")
    history[[datecol]] <- as.Date(history[[datecol]])
  }
  
  if( class(primary_tweets[[createdcol]]) != "Date" ){
    warning("Converting created at column to class date")
    primary_tweets[[createdcol]] <- as.Date(primary_tweets[[createdcol]])
  }
  
  if(  !is.numeric(history[[followercol]]) ){ 
    warning("Converting follower column to class numeric")
    history[[followercol]] <- as.numeric(history[[followercol]])
  }
  
  # Order date from past to present
  history <- history[order(history$date, decreasing = FALSE), ]
  
  history$follower_growth <- c(0, diff(history$followers) )
  
  # if n is too large, just get the most possible 
  top_tweets_index <- na.omit( 
    order(primary_tweets[[retweet_x_like]], decreasing = TRUE)[1:n]
  )
  
  top_tweets <- primary_tweets[top_tweets_index, ]
  
  g <- ggplot(history) +
    aes_string(x = datecol, y = "follower_growth") +
    geom_line() + 
    xlab("") + 
    ylab("") + 
    theme_classic() +
    scale_x_date(date_labels = "%b-%Y") +
    # as.numeric so that it plays nice with plotly
    geom_vline(xintercept = as.numeric( top_tweets[[createdcol]] ), 
               linetype = "dashed", color = "#6f63d6", size = 0.25)
  
  ggplotly(g) %>% 
    config(displaylogo = FALSE, displayModeBar = TRUE) %>% 
    layout(title ="Twitter Follower Growth & Top Tweets",
           margin = list(t = 75)) 
  
}
