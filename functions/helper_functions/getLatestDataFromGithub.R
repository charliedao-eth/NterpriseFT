#' @name getLatestDataFromGithub
#'
#' @title Get the Latest Data From GitHub
#' 
#' @description This helper function pulls all of our MVP data and assigns the
#'   dataframes as global variables via <<-. Data is sourced from here and reads
#'   both CSVs and JSON files:
#'   https://github.com/charliedao-eth/NterpriseFT/tree/main/data
#' 
#' @example
#'   getLatestDataFromGithub()
#' 
#' @import jsonlite
#' 
#' @export
getLatestDataFromGithub <<- function() {
  message('Pulling data from https://github.com/charliedao-eth/NterpriseFT/tree/main/data')
  
  # csv data
  bayc_history <<- read.csv('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/e51385cf8b34e6a6fde58da4216fe90106a09b6c/data/bayc_history.csv')
  bayc_sales <<- read.csv('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/bayc_sales.csv')
  
  mayc_sales <<- read.csv('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/mayc_sales.csv')
  
  treeverse_history <<- read.csv('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/treeverse_history.csv')
  treeverse_sales <<- read.csv('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/treeverse_sales.csv')
  
  wow_history <<- read.csv('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/wow_history.csv')
  wow_sales <<- read.csv('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/wow_sales.csv')
  
  etherscan_average_daily_gas_attribute <<- read.csv('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/etherscan_average_daily_gas_attribute.csv')
  
  # json data
  bayc_owners <<- jsonlite::fromJSON('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/bayc_owners.json')
  bayc_tweets_all <<- as.data.frame(jsonlite::fromJSON('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/bayc_tweets.json')[1])
  bayc_tweets_primary <<- as.data.frame(jsonlite::fromJSON('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/bayc_tweets.json')[2])
  
  mayc_owners <<- jsonlite::fromJSON('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/mayc_owners.json')
  
  treevese_owners <<- jsonlite::fromJSON('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/treeverse_owners.json')
  treeverse_tweets_all <<- as.data.frame(jsonlite::fromJSON('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/treeverse_tweets.json')[1])
  treeverse_tweets_primary <<- as.data.frame(jsonlite::fromJSON('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/treeverse_tweets.json')[2])
  
  wow_owners <<- jsonlite::fromJSON('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/wow_owners.json')
  wow_tweets_all <<- as.data.frame(jsonlite::fromJSON('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/wow_tweets.json')[1])
  wow_tweets_primary <<- as.data.frame(jsonlite::fromJSON('https://raw.githubusercontent.com/charliedao-eth/NterpriseFT/main/data/wow_tweets.json')[2])
}
