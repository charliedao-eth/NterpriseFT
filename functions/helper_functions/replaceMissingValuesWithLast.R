#' @name replaceMissingValuesWithLast
#'
#' @title Replace Missing Values with Last
#' 
#' @description This function takes a time series dataset and fills in the
#'   missing values represented as 0 with previous value within the dataframe.
#'   Useful for preventing random drops to 0 within a time series graph.
#'   
#'   Dataframe MUST include a column named "date", and one or more value columns
#'   that are continuous.
#'   
#'   Dataframe Input Format:
#'   +------------+--------------+
#'   | date       | <your_value> |
#'   +------------+--------------+
#'   | 01-01-2020 | 157          |
#'   | 01-02-2020 | 230          |
#'   | 01-03-2020 | 0            |
#'   | 01-04-2020 | 312          |
#'   +------------+--------------+
#'   
#'   Dataframe Output Format:
#'   +------------+--------------+
#'   | date       | <your_value> |
#'   +------------+--------------+
#'   | 01-01-2020 | 157          |
#'   | 01-02-2020 | 230          |
#'   | 01-03-2020 | 230          |
#'   | 01-04-2020 | 312          |
#'   +------------+--------------+
#' 
#' @param dataframe A time series dataframe consisting of dates and one or more
#'   value columns that are continuous.
#' 
#' @export
replaceMissingValuesWithLast <- function(dataframe) {
  df = as.data.frame(dataframe)
  
  start <- min(df$date)
  end   <- max(df$date)
  finalDf <- as.data.frame(df['date'])
  
  # iterate through each non-date column and create a subset of only date and
  # the select column
  for (col in colnames(df)[colnames(df) != "date"]) {
    date <- start
    iterateDf <- df[c('date', col)]
    
    # iterate through each date and 1) determine if value is 0, 2) if 0 present
    # determine the previous value, 3) replace the 0 with the last value
    while (date <= end) {
      if (iterateDf[iterateDf['date'] == as.character(date), col] == 0) {
        lastValue = iterateDf[iterateDf['date'] == as.character(date - 1), col]
        iterateDf[iterateDf['date'] == as.character(date), col] <- lastValue
      }
      date <- date + 1 
    }
    
    # Once iterating through dates are complete merge updated dataframe
    finalDf <- left_join(finalDf, iterateDf, by='date')
  }
  return(finalDf)
}
