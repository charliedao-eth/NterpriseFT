#' @name plot_follower_count
#' 
#' @title Follower Count Over Time
#' 
#'@description Creates a plot of Twitter follower over time,
#' 
#' @param dataframe A time series dataframe consisting of dates and one or more
#'   value columns that are continuous.
#' @param nftName Name of the NFT project to pass onto the title.
#' 
#' @export
plot_follower_count <- function(dataframe, nftName) {
  df <- as.data.frame(dataframe) %>%
    select(date, followers)
  
  fillDf <- fillMissingDates(df)
  replaceDf <- replaceMissingValuesWithLast(fillDf)
  
  plotTitle <- paste0(nftName, ' Twitter Followers Over Time')
  
  plotTimeSeries(dataframe=replaceDf, title=plotTitle, logScale=FALSE, savePlotData=TRUE)
}
