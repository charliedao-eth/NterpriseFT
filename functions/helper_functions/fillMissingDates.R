#' @name fillMissingDates
#'
#' @title Fill Missing Dates in Time Series
#' 
#' @description This function takes a time series dataset and fills in the
#'   missing dates between the min and max date present, as well as replace
#'   the new null values with 0. Useful for preventing gaps within a time
#'   series graph.
#'   
#'   Dataframe MUST include a column named "date", and one or more value columns
#'   that are continuous.
#'   
#'   Dataframe Input Format:
#'   +------------+--------------+
#'   | date       | <your_value> |
#'   +------------+--------------+
#'   | 01-01-2020 | 100          |
#'   | 01-02-2020 | 100          |
#'   | 01-04-2020 | 100          |
#'   +------------+--------------+
#'   
#'   Dataframe Output Format:
#'   +------------+--------------+
#'   | date       | <your_value> |
#'   +------------+--------------+
#'   | 01-01-2020 | 100          |
#'   | 01-02-2020 | 100          |
#'   | 01-03-2020 | 0            |
#'   | 01-04-2020 | 100          |
#'   +------------+--------------+
#' 
#' @param dataframe A time series dataframe consisting of dates and one or more
#'   value columns that are continuous.
#' 
#' @import dplyr
#' 
#' @export
fillMissingDates <- function(dataframe) {
  df = as.data.frame(dataframe)
  
  date = seq(min(df$date), max(df$date), by="days")
  dateRangeDf <- as.data.frame(date)
  
  filledDatesDf <- dateRangeDf %>%
    left_join(., df, by='date') %>%
    replace(is.na(.), 0)
  
  return(filledDatesDf)
}
