#' @name getDailySalesCount
#'
#' @title Get Daily Sales Count
#' 
#' @description This function take a dataframe and date column to determine
#'   the daily sale count.
#'   
#'   Dataframe Input Format:
#'   +------------+--------------+
#'   | dateCol    | value        |
#'   +------------+--------------+
#'   | 01-01-2020 | 100          |
#'   | 01-01-2020 | 200          |
#'   | 01-01-2020 | 300          |
#'   | 01-02-2020 | 150          |
#'   | 01-02-2020 | 250          |
#'   +------------+--------------+
#'   
#'   Dataframe Output Format:
#'   +------------+-------+
#'   | dateCol    | count |
#'   +------------+-------+
#'   | 01-01-2020 | 3     |
#'   | 01-02-2020 | 2     |
#'   +------------+-------+
#' 
#' @param dataframe A time series dataframe consisting of dates and one or more
#'   value columns that are continuous.
#' @param dateCol <string> The name of your date column to aggregate by.
#' 
#' @import dplyr
#' 
#' @export
getDailySalesCount <- function(dataframe, dateCol) {
  message('Preparing daily sales count data...')
  df <- as.data.frame(dataframe)
  
  # data checks
  if(!(dateCol %in% colnames(df))) { 
    stop(paste0('Expected ', dateCol, ' column not found in dataframe.'))
  }
  
  # prepare dataframe
  names(df)[names(df) == dateCol] <- 'date'
  dailySalesCountDf <- df %>%
    mutate(date = as.Date(date)) %>%
    group_by(date) %>%
    summarise(sales_count = n())
  
  return(dailySalesCountDf)
}
